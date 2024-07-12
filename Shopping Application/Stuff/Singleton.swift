//
//  UserInformation.swift
//  Shopping Application
//
//  Created by 김성률 on 7/11/24.
//

import UIKit

class UserInfo {
    
    static let shared = UserInfo.init()
    
    let userDefault = UserDefaults.standard
    
    private init() { }
    
    var userName: String {
        get {
            return userDefault.string(forKey: "userName") ?? "DefaultUser"
        }
        set {
            userDefault.set(newValue, forKey: "userName")
        }
    }
    
    var profileNumber: Int {
        get {
            return userDefault.integer(forKey: "profileNumber")
        }
        set {
            userDefault.set(newValue, forKey: "profileNumber")
        }
    }
    
    var joinDate: String {
        get {
            return userDefault.string(forKey: "joinDate") ?? ""
        }
        set {
            userDefault.set(newValue, forKey: "joinDate")
        }
    }
    
    var recentSearchText: String {
        get {
            return userDefault.string(forKey: "recentSearchText") ?? ""
        }
        set {
            userDefault.set(newValue, forKey: "recentSearchText")
        }
    }
}

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    private init() { }
    
    func today(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        
        return format.string(from: date)
    }
}

class NumberFormatterManager {
    
    static let shared = NumberFormatterManager()
    
    private init() { }
    
    func Comma(_ number: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        let result = format.string(for: number)
        guard let decimalNumber = result else { return ""}
        
        return decimalNumber
    }
}
