//
//  SearchResultViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/12/24.
//

import Foundation
import RealmSwift

final class SearchResultViewModel {
    
    var inputText: Observable<String?> = Observable(nil)
    var inputButton: Observable<Int?> = Observable(nil)
    var inputPage: Observable<Void?> = Observable(nil)
    
    var inputLike: Observable<DBTable?> = Observable(nil)
    var inputUnLike: Observable<DBTable?> = Observable(nil)
    
    var outputList: Observable<[SearchResultDetail]> = Observable([])
    var outputCount: Observable<Int> = Observable(0)
    
    var outputScrollToTop: Observable<Void?> = Observable(nil)
    var outputPagination: Observable<Void?> = Observable(nil)
    
    let realm = try! Realm()
    let realmrepository = RealmRepository()
    var folderList: [Folder] = []
    var buttonTag: Int = 0
    var totalPage = 0
    var start = 1
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        
        inputText.bind { [weak self] text in
            guard let text = text else { return }
            self?.fetchData(text: text, buttonTag: 0, start: 1)
        }
        
        inputButton.bind { [weak self] value in
            if value == self?.buttonTag { return }
            guard let value else { return }
            
            self?.buttonTag = value
            self?.fetchData(text: UserInfo.shared.recentSearchText, buttonTag: value, start: 1)
        }
        
        inputPage.bind { [weak self] value in
            guard let value else { return }
            self?.loadMoreData()
        }
        
        inputLike.bind { [weak self] value in
            guard let value else { return }
            self?.folderList = self?.realmrepository.fetchFolder() ?? []
            self?.addDataInFolder(data: value)
        }
        
        inputUnLike.bind { [weak self] value in
            guard let value else { return }
            self?.deleteDataInFolder(data: value)
        }
        
        outputList.bind { [weak self] value in
            if self?.start == 1 && value.count > 0 {
                self?.outputScrollToTop.value = ()
            } else if self?.start ?? 1 > 1 && value.count > 0 {
                self?.outputPagination.value = ()
            }
        }
    }
    
    private func fetchData(text: String, buttonTag: Int, start: Int) {
        self.buttonTag = buttonTag
        self.start = start
        
        APIManager.shared.callRequest(text: text, start: start, buttonTag: buttonTag) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputList.value = value.items
                self?.outputCount.value = value.total
                self?.totalPage = value.total
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadMoreData() {
        start += 30
        guard totalPage != start else { return }
        
        APIManager.shared.callRequest(text: UserInfo.shared.recentSearchText, start: start, buttonTag: buttonTag) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputList.value.append(contentsOf: value.items)
            case .failure(let error):
                print(error)
            }
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
        try! realm.write {
            realm.delete(data)
        }
    }
}
