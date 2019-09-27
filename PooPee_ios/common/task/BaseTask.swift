//
//  BaseTask.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 10. 23..
//  Copyright © 2018년 EMEYE. All rights reserved.
//
import Alamofire

class BaseTask {
    
    func requestPost(url: String, params: Parameters = Parameters(), onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        Alamofire.request(
            NetDefine.BASE_APP + url,
            method: .post,
            parameters: params,
            encoding: URLEncoding.default
            )
            .responseJSON { (response) in
                self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func requestGet(url: String, params: Parameters = Parameters(), onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        Alamofire.request(
            NetDefine.BASE_APP + url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default
            )
            .responseJSON { (response) in
                self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func requestPut(url: String, params: Parameters = Parameters(), onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        Alamofire.request(
            NetDefine.BASE_APP + url,
            method: .put,
            parameters: params,
            encoding: URLEncoding.default
            )
            .responseJSON { (response) in
                self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func requestDelete(url: String, params: Parameters = Parameters(), onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        Alamofire.request(
            NetDefine.BASE_APP + url,
            method: .delete,
            parameters: params,
            encoding: URLEncoding.default
            )
            .responseJSON { (response) in
                self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func requestPostFullUrl(url: String, params: Parameters = Parameters(), onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        Alamofire.request(
            url,
            method: .post,
            parameters: params,
            encoding: URLEncoding.default
            )
            .responseJSON { (response) in
                self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func upload(url: String, params: Parameters = Parameters(), fileParams: [FileParam], onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        print("url : \(url)")
        print("params : \(params.description)")
        
        let multipartFormData: (MultipartFormData) -> Void = { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            for fileParam in fileParams {
                multipartFormData.append(fileParam.file_data!, withName: fileParam.key, fileName: fileParam.key + ".png", mimeType: "image/png")
            }
        }
        
        Alamofire.upload(
            multipartFormData: multipartFormData,
            usingThreshold: UInt64.init(),
            to: NetDefine.BASE_APP + url,
            method: .post,
            headers: ["Content-type": "multipart/form-data"]
            )
        { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
                }
            case .failure(let error):
                print(error)
                onFailed(9)
            }
        }
    }
    
    func download(url: String, fileUrl: URL, onProgress: @escaping (_ progress: Progress)->(), onSuccess: @escaping (_ data: DownloadResponse<Data>)->()) {
        print("url : \(url)")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(
            url,
            to: destination
            )
            .downloadProgress { (progress) in
                onProgress(progress)
            }
            .responseData { (data) in
                print("download_complete: \(data.destinationURL!)")
                onSuccess(data)
        }
    }
    
    func onResponse(response: DataResponse<Any>, onSuccess: @escaping (_ response: NSDictionary)->(), onFailed: @escaping (_ statusCode: Int)->()) {
        var statusCode = 9
        if (response.response != nil) {
            statusCode = response.response!.statusCode
            print("statusCode : \(statusCode)")
        }
        
        if let result = response.result.value {
            let jsonResult = result as? NSDictionary
            if (jsonResult != nil) {
                print("response : \(jsonResult!.description)")
                onSuccess(jsonResult!)
            } else {
                print("onFailed")
                onFailed(statusCode)
            }
        } else {
            print("onFailed")
            onFailed(statusCode)
        }
    }
    
}
