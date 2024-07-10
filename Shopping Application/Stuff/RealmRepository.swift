//
//  RealmRepository.swift
//  Shopping Application
//
//  Created by 김성률 on 7/8/24.
//

import UIKit
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func fetchFolder() -> [Folder] {
        let value = realm.objects(Folder.self)
        return Array(value)
    }
    
    func removeFolder(_ folder: Folder) {
        
        do {
            try realm.write {
                realm.delete(folder.detail)
                realm.delete(folder)
                print("folder remove succeed")
            }
            
        } catch {
            print("folder remove failed")
        }
        
    }
    
    func createItem(_ data: DBTable, folder: Folder) {

        do {
            try! realm.write {
                folder.detail.append(data)

                print("Realm Create Succeed")
            }
        } catch {
            print("Realm Error")
        }
        
    }
    
    func readAllItem() -> Results<DBTable> {
        return realm.objects(DBTable.self).sorted(byKeyPath: "price", ascending: false)
    }
    
    func deleteItem(_ data: DBTable) {
        try! realm.write {
            realm.delete(data)
        }
    }
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
}

