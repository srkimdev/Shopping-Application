//
//  DBTable.swift
//  Shopping Application
//
//  Created by 김성률 on 7/7/24.
//

import Foundation
import RealmSwift

class DBTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var productId: String
    @Persisted var productImage: String
    @Persisted var productCompany: String
    @Persisted var productName: String
    @Persisted var productPrice: String
    @Persisted var productLike: Bool
    @Persisted var productLink: String
    
    convenience init(productId: String, productImage: String, productCompany: String, productName: String, productPrice: String, productLink: String) {
        self.init()
        self.productId = productId
        self.productImage = productImage
        self.productCompany = productCompany
        self.productName = productName
        self.productPrice = productPrice
        self.productLink = productLink
        self.productLike = true
    }
}

class Folder: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    
    @Persisted var detail: List<DBTable>
    
}


