//
//  ReusableProtocol.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit

protocol ReusableProtocol {
    
    static var identifier: String { get }
    
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
