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

enum CustomDesign {
    
    static let viewBackgoundColor: UIColor = .white
    static let itemTintColor: UIColor = .black
    static let profileBorderWidth3: CGFloat = 3
    static let profileBorderWidth1: CGFloat = 1
    static let lineColor: UIColor = .systemGray5
    static let orange: UIColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
    static let likeImage: UIImage = UIImage(named: "like_selected")!
    static let unlikeImage: UIImage = UIImage(named: "like_unselected")!
    
}

struct ConstantTable {
    
    static var likeCount = 0
    static let sortSelect = ["sim", "date", "dsc", "asc"]
    static let settingCell = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    static let arrayButton = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
    
    static func formatNumberString(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

struct WebViewInfo {
    
    let text: String
    let titlelabel: String
    let key: String
    
}
