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
        joinDate = Date()
        recentSearchText = ""
    }
    
    private var userName: String
    private var profileNumber: Int
    private var joinDate: Date
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
    
    func getJoinDate() -> Date {
        return joinDate
    }
    
    func updateJoinDate(_ date: Date) {
        joinDate = date
    }
    
    func getRecentSearchText() -> String {
        return recentSearchText
    }
    
    func updateRecentSearchText(_ text: String) {
        recentSearchText = text
    }
}
