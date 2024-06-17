//
//  Struct.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit

struct SearchResult: Codable {
    
    let total: Int
    let display: Int
    let items: [SearchResultDetail]
    
}

struct SearchResultDetail: Codable {
    
    let title: String
    let link: String
    let image: String
    let mallName: String
    let productId: String
    let lprice: String
    
}

enum ProfileMode: String {
    
    case setup = "setup"
    case edit = "edit"
    
}
