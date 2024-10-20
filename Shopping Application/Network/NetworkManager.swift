//
//  APIManager.swift
//  Shopping Application
//
//  Created by 김성률 on 7/12/24.
//

import UIKit
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest(text: String, start: Int, buttonTag: Int, completionHandler: @escaping (Result<SearchResult, APIError>) -> Void) {

        let router = RouterPattern.shopping(text: text, start: start, buttonTag: buttonTag)
        
        AF.request(router.endpoint, method: router.method, headers: router.header).responseDecodable(of: SearchResult.self) { response in
            
            switch response.result {
                
            case .success(let value):
                completionHandler(.success(value))
                print(value)
            // Custom responseSerlizier
            case .failure:
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorCode = json["errorCode"] as? String 
                {
                    let apiError = APIError.from(errorCode: errorCode)
                    completionHandler(.failure(apiError))
                } else {
                    let statusCode = response.response?.statusCode ?? -1
                    let apiError = APIError.from(errorCode: "statusCode: \(statusCode)")
                    completionHandler(.failure(apiError))
                }
            }
        }
    }
}
