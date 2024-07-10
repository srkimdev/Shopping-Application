//
//  UserDefaultsManager.swift
//  Shopping Application
//
//  Created by 김성률 on 6/23/24.
//

import Foundation

class UserDefaultsManager {
    
    static var userName: String {
            
        get { return UserDefaults.standard.string(forKey: "userName") ?? ""}
        
        set { UserDefaults.standard.set(newValue, forKey: "userName") }
            
    }
    
    static var goToSearch: Bool {
            
        get { return UserDefaults.standard.bool(forKey: "goToSearch") }
        
        set { UserDefaults.standard.set(newValue, forKey: "goToSearch") }
            
    }
    
    static var joinDate: String {
            
        get { return UserDefaults.standard.string(forKey: "joinDate")! }
        
        set { UserDefaults.standard.set(newValue, forKey: "joinDate") }
            
    }
    
    static var profileNumber: Int {
            
        get { return UserDefaults.standard.integer(forKey: "profileNumber") }
        
        set { UserDefaults.standard.set(newValue, forKey: "profileNumber") }
            
    }
    
    static var fromWhere: Bool {
        
        get { return UserDefaults.standard.bool(forKey: "fromWhere") }
        
        set { UserDefaults.standard.set(newValue, forKey: "fromWhere") }
        
    }
    
    static var totalLike: Int {
        
        get { return UserDefaults.standard.integer(forKey: "totalLike") }
        
        set { UserDefaults.standard.set(newValue, forKey: "totalLike") }
        
    }

    
}
