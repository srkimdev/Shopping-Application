//
//  RouterPattern.swift
//  Shopping Application
//
//  Created by 김성률 on 7/21/24.
//

import Foundation
import Alamofire

enum RouterPattern {
    
    case shopping(text: String, start: Int, buttonTag: Int)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/search/shop.json?"
    }
    
    var endpoint: URL {
        switch self {
        case .shopping(let text, let start, let buttonTag):
            return URL(string: baseURL + "query=\(text)&display=30&start=\(start)&sort=\(ConstantTable.sortSelect[buttonTag])")!
        }
    }
    
    var header: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIkey.Id,
            "X-Naver-Client-Secret": APIkey.Secret
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .shopping:
            return ["language": "ko-KR"]
        }
    }
}
