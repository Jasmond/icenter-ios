//
//  NetworkBridge.swift
//  iCenter
//
//  Created by Jasmond Luk on 8/5/2026.
//  Copyright © 2026 Dreamware Limited. All rights reserved.
//

import Foundation
import Alamofire

/// NetworkManager Bridge for Objective-C migration.
/// Uses @objcMembers to ensure all methods are accessible in your .m files.
@objcMembers
class NetworkManager: NSObject {
    
    // MARK: - Singleton Instance
    static let shared = NetworkManager()
    
    // MARK: - GET Request
    /// Replaces manual NSURLSession with Alamofire's GET implementation.
    /// Returns raw Data to match legacy completion blocks.
    func callGET(urlString: String, completion: @escaping @Sendable (Bool, Data?) -> Void) {
        AF.request(urlString, method: .get)
            .validate(statusCode: 200..<300) // Automatically checks for status codes 200-299
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(true, data)
                case .failure(let error):
                    print("Alamofire GET Error: \(error)")
                    completion(false, nil)
                }
            }
    }
    
    func callGETSynchronous(urlString: String) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        var resultData: Data? = nil
        
        // Create a high-priority queue
        let highPrioQueue = DispatchQueue.global(qos: .userInteractive)
            
        // Use responseData instead of responseJSON
        AF.request(urlString).validate().responseData(queue: highPrioQueue) { response in
                switch response.result {
                case .success(let data):
                    resultData = data
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    resultData = nil
                }
                // Always signal to prevent a permanent hang
                semaphore.signal()
            }
            
            // Wait for the request to finish
            _ = semaphore.wait(timeout: .distantFuture)
            
            return resultData
        }
    
    // MARK: - POST Request
    /// Replaces manual NSMutableURLRequest with JSON encoding.
    /// Handles application/json headers and body serialization automatically.
    func callPOST(urlString: String, parameters: [String: Any]?, completion: @escaping (Bool, Data?) -> Void) {
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default) // Sends as JSON body
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(true, data)
                case .failure(let error):
                    print("Alamofire POST Error: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
    }
    
    func callPOSTSynchronous(urlString: String, parameters: [String: Any]?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        var resultData: Data? = nil
        
        // Create a high-priority queue
        let highPrioQueue = DispatchQueue.global(qos: .userInteractive)
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default) // Sends as JSON body
            .validate()
            .responseData(queue: highPrioQueue) { response in
                switch response.result {
                case .success(let data):
                    resultData = data
                case .failure(let error):
                    print("Alamofire POST Error: \(error.localizedDescription)")
                    resultData = nil
                }
                // Always signal to prevent a permanent hang
                semaphore.signal()
            }
        
        // Wait for the request to finish
        _ = semaphore.wait(timeout: .distantFuture)
        
        return resultData
    }
    
    func callPOSTMultipart(url: String, body: Data, boundary: NSString, completion: @escaping (Bool, Data?) -> Void) {
        let contentType = "multipart/form-data; boundary=\(boundary)"
        let headers: HTTPHeaders = ["Content-Type": contentType]
        
        // Use AF.upload instead of AF.request for raw data streams
        AF.upload(body, to: url, method: .post, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(true, data)
                case .failure(let error):
                    print("Alamofire Multipart Error: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
    }
    
    func uploadMultipart(url: String, body: Data, boundary: String, completion: @escaping (Data?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        AF.upload(body, to: url, method: .post, headers: headers)
            .responseData { response in
                // Return the raw data and error to match your completionBlock(id, NSError)
                completion(response.data, response.error)
            }
    }
    
    func sendInstantMessage(url: String, parameters: [String: Any], files: [Any], completion: @escaping (Data?, Error?) -> Void) {
        
        // Explicitly calling AF.upload with the multipartFormData closure
        AF.upload(multipartFormData: { formData in
            
            // 1. Recursive function to handle nested Dictionary/Array parameters
            func append(_ value: Any, key: String) {
                if let dictionary = value as? [String: Any] {
                    for (nestedKey, nestedValue) in dictionary {
                        append(nestedValue, key: "\(key)[\(nestedKey)]")
                    }
                } else if let array = value as? [Any] {
                    // FIXED: Added .enumerated() to get (index, value)
                    for (index, nestedValue) in array.enumerated() {
                        append(nestedValue, key: "\(key)[\(index)]")
                    }
                } else {
                    // Base case: Convert simple value to String and append
                    let stringValue = "\(value)"
                    if let data = stringValue.data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }
            }
            
            // 1. Append Text Parameters
            for (key, value) in parameters {
                append(value, key: key)
            }
            
            // 2. Append File Data
            // Cast the Obj-C array to your record type
            let photoRecords = files as? [MessagePhotoRecord] ?? []
            
            for (index, record) in photoRecords.enumerated() {
                guard let fileUrl = record.internalurl else { continue }
                
                // Attempt to load data from the local file path
                if let fileData = try? Data(contentsOf: fileUrl) {
                    let fileType = record.filetype ?? "image"
                    let fileName = record.filename ?? "file\(index)"
                    
                    if fileType == "image" {
                        formData.append(fileData, withName: "image\(index)", fileName: "abc\(index).png", mimeType: "image/png")
                    } else if fileType == "pdf" {
                        formData.append(fileData, withName: "pdf\(index)", fileName: fileName, mimeType: "application/pdf")
                    } else if fileType == "video" {
                        formData.append(fileData, withName: "video\(index)", fileName: "video\(index).mp4", mimeType: "video/mp4")
                    } else if fileType == "audio" {
                        formData.append(fileData, withName: "audio\(index)", fileName: "audio\(index).mp3", mimeType: "audio/mpeg")
                    }
                }
            }
            
        }, to: url) // <--- The 'to:' label is MANDATORY here
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

