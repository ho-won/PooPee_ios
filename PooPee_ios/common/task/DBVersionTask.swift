//
//  DBVersionTask.swift
//  PooPee_ios
//
//  Created by ho1 on 20/09/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation
import UIKit

class DBVersionTask {
    var progressBar: UIProgressView! = nil
    var dbVer = 0
    
    var onSuccess: ()->()
    var onFalied: ()->()
    
    init(progress: UIProgressView!, onSuccess: @escaping ()->(), onFalied: @escaping ()->()){
        self.progressBar = progress
        self.onSuccess = onSuccess
        self.onFalied = onFalied
        start()
    }
    
    /*
     * 차량 DB 버전체크
     */
    func start() {
        BaseTask().request(url: NetDefine.DB_CHECK, method: .post
            , onSuccess: { response in
                if (response.getInt("rst_code") == 0) {
                    self.dbVer = response.getInt("db_ver")
                    
                    if (SharedManager.dbVer == self.dbVer) {
                        self.onSuccess()
                    } else {
                        let fileName = response.getString("file_name")
                        let url = NetDefine.BASE_APP + "sql/" + fileName
                        self.downloadDB(url: url, fileName: fileName)
                    }
                } else {
                    self.onFalied()
                }
        }
            , onFailed: { statusCode in
                self.onFalied()
        })
    }
    
    /*
     * db download
     */
    public func downloadDB(url: String, fileName: String) {
        if (progressBar != nil) {
            progressBar.isHidden = false
        }
        
        let fileUrl = MyUtil.getSaveFileUrl(fileName: url)
        
        BaseTask().download(url: url, fileUrl: fileUrl
            , onProgress: { progress in
                if (self.progressBar != nil) {
                    DispatchQueue.main.async {
                        self.progressBar.setProgress(Float(progress.fractionCompleted * 100), animated: true)
                    }
                }
        }
            , onSuccess: { data in
                let oldDbVersion = SharedManager.dbVer
                let newDbVersion = self.dbVer
                for i in oldDbVersion ..< newDbVersion {
                    do {
                        let path = ObserverManager.getPath() + "toilet_v" + String(i) + ".sqlite"
                        try FileManager.default.removeItem(atPath: path)
                    }
                    catch {
                        
                    }
                }
                
                SharedManager.dbVer = self.dbVer
                self.onSuccess()
        })
    }
    
}
