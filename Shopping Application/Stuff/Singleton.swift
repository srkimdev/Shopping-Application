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
    }
    
    private var userName: String
    private var profileNumber: Int
    
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
}

class Mode {
    
    static let shared = Mode.init()
    
    private init() { }
    
    
    
}
