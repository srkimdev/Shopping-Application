//
//  APIManager.swift
//  Shopping Application
//
//  Created by 김성률 on 7/12/24.
//

import Foundation
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func callRequest(text: String, start: Int, buttonTag: Int, completionHandler: @escaping (SearchResult) -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(ConstantTable.sortSelect[buttonTag])"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIkey.Id,
            "X-Naver-Client-Secret": APIkey.Secret
        ]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
                
            case .success(let value):
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
