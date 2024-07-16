//
//  SearchSaveViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/15/24.
//

import Foundation
import RealmSwift

class SearchSaveViewModel {
    
    var inputLike: Observable<DBTable?> = Observable(nil)
    var inputUnLike: Observable<DBTable?> = Observable(nil)
    var outputResult: Observable<Void?> = Observable(nil)
    
    let realm = try! Realm()
    let realmrepository = RealmRepository()
    var folderList: [Folder] = []
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        
        inputLike.bind { [weak self] value in
            guard let value else { return }
            self?.folderList = self?.realmrepository.fetchFolder() ?? []
            self?.addDataInFolder(data: value)
        }
        
        inputUnLike.bind { [weak self] value in
            guard let value else { return }
            self?.outputResult.value = ()
            self?.deleteDataInFolder(data: value)
        }
    }
    
    private func addDataInFolder(data: DBTable) {
         
        try! realm.write {
            if data.mallName == "네이버" {
                folderList[0].detail.append(data)
            } else if data.mallName == "쿠팡" {
                folderList[1].detail.append(data)
            } else {
                folderList[2].detail.append(data)
            }
        }
    }
    
    private func deleteDataInFolder(data: DBTable) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
}




