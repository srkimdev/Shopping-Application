//
//  UserInformation.swift
//  Shopping Application
//
//  Created by 김성률 on 7/11/24.
//

import UIKit

class UserInformation {
    
    static let shared = UserInformation.init()
    
    private init() { 
        userName = UserDefaults.standard.string(forKey: "userName") ?? "DefaultUser"
        profileNumber = UserDefaults.standard.integer(forKey: "profileNumber")
        joinDate = ""
        recentSearchText = ""
    }
    
    private var userName: String
    private var profileNumber: Int
    private var joinDate: String
    private var recentSearchText: String
    
    func getUserName() -> String {
        return userName
    }
    
    func updateUserName(_ name: String) {
        userName = name
        UserDefaults.standard.setValue(userName, forKey: "userName")
    }
    
    func getProfileNumber() -> Int {
        return profileNumber
    }
    
    func updateProfileNumber(_ number: Int) {
        profileNumber = number
        UserDefaults.standard.setValue(profileNumber, forKey: "profileNumber")
    }
    
    func getJoinDate() -> String {
        return joinDate
    }
    
    func updateJoinDate(_ date: Date) {
        joinDate = DateFormatterManager.shared.today(date)
        UserDefaults.standard.setValue(joinDate, forKey: "joinDate")
    }
    
    func getRecentSearchText() -> String {
        return recentSearchText
    }
    
    func updateRecentSearchText(_ text: String) {
        recentSearchText = text
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
