//
//  BaseTask.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 10. 23..
//  Copyright © 2018년 EMEYE. All rights reserved.
//
import Alamofire

class BaseTask {
    
    func request(
        url: String,
        method: HTTPMethod = .get,
        params: Parameters = Parameters(),
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders = HTTPHeaders(),
        fullUrl: Bool = false,
        onSuccess: @escaping (_ response: NSDictionary)->(),
        onFailed: @escaping (_ statusCode: Int)->()
    ) {
        var nUrl = url
        if (!fullUrl) {
            nUrl = NetDefine.BASE_APP + url
        }
        
        print("url : \(url)")
        print("params : \(params.description)")
        
        AF.request(
            nUrl,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseJSON { (response) in
            self.onResponse(response: response, onSuccess: onSuccess, onFailed: onFailed)
        }
    }
    
    func upload(
        url: String,
        params: Parameters = Parameters(),
        fileParams: [FileParam],
        onSuccess: @escaping (_ response: NSDictionary)->(),
        onFailed: @escaping (_ statusCode: Int)->()
    ) {
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
        
        AF.upload(
            multipartFormData: multipartFormData,
            to: NetDefine.BASE_APP + url,
            method: .post,
            headers: ["Content-type": "multipart/form-data"]
        )
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { data in
            //Do what ever you want to do with response
            self.onResponse(response: data, onSuccess: onSuccess, onFailed: onFailed)
        })
    }
    
    func download(
        url: String,
        fileUrl: URL,
        onProgress: @escaping (_ progress: Progress)->(),
        onSuccess: @escaping (_ data: AFDownloadResponse<Data>)->()
    ) {
        print("url : \(url)")
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(
            url,
            to: destination
        )
        .downloadProgress { (progress) in
            onProgress(progress)
        }
        .responseData { (data) in
            onSuccess(data)
        }
    }
    
    func onResponse(
        response: AFDataResponse<Any>,
        onSuccess: @escaping (_ response: NSDictionary)->(),
        onFailed: @escaping (_ statusCode: Int)->()
    ) {
        var statusCode = 9
        if (response.response != nil) {
            statusCode = response.response!.statusCode
            print("statusCode : \(statusCode)")
        }
        
        switch response.result {
        case .success(let data):
            let jsonResult = data as? NSDictionary
            if (jsonResult != nil) {
                print("response : \(jsonResult!.description)")
                onSuccess(jsonResult!)
            } else {
                print("onFailed")
                onFailed(statusCode)
            }
        case .failure(let err):
            print("err발생")
            print(err)
        }
    }
    
}

extension Parameters {
    mutating func put(_ key: String, _ value: Any) {
        updateValue(value, forKey: key)
    }
}
