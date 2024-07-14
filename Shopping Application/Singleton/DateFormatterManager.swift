//
//  DateFormatter.swift
//  Shopping Application
//
//  Created by 김성률 on 7/13/24.
//

import Foundation

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    private init() { }
    
    func today(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        
        return format.string(from: date)
    }
}
