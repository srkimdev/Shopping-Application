//
//  SearchResultViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/12/24.
//

import Foundation
import RealmSwift

final class SearchResultViewModel {
    
    var callAPI: Observable<Void> = Observable(())
    var inputButton: Observable<Int?> = Observable(nil)
    var inputPagination: Observable<Void> = Observable(())
    
//    var inputLike: Observable<DBTable?> = Observable(nil)
//    var inputUnLike: Observable<DBTable?> = Observable(nil)
    
    var outputList: Observable<[SearchResultDetail]> = Observable([])
    var outputCount: Observable<Int> = Observable(0)
    
    var outputScrollToTop: Observable<Void?> = Observable(nil)
    var outputPagination: Observable<Void?> = Observable(nil)
    
    private let realmrepository = RealmRepository()
    
    var searchText: String
    var buttonTag: Int = 0
    var start = 1
    var totalPage = 0
    
    init(searchText: String) {
        self.searchText = searchText
        
        callAPI
            .bind { [weak self] _ in
                guard let self else { return }
                fetchData(text: searchText, buttonTag: buttonTag, start: start)
            }
        
        inputButton
            .bind { [weak self] value in
                if value == self?.buttonTag { return }
                guard let value else { return }
                
                self?.buttonTag = value
                self?.fetchData(text: UserInfo.shared.recentSearchText, buttonTag: value, start: 1)
            }
        
        inputPagination
            .bind { [weak self] value in
                guard let self else { return }
                loadMoreData()
            }
        
        outputList
            .bind { [weak self] value in
                guard let self else { return }
                
                if start == 1 && value.count > 0 {
                    outputScrollToTop.value = ()
                } else if start > 1 && value.count > 0 {
                    outputPagination.value = ()
                }
            }
        
    }

    private func fetchData(text: String, buttonTag: Int, start: Int) {
        self.buttonTag = buttonTag
        self.start = start
        
        NetworkManager.shared.callRequest(text: text, start: start, buttonTag: buttonTag) { response in
            switch response {
            case .success(let value):
                self.outputList.value = value.items
                self.outputCount.value = value.total
                self.totalPage = value.total
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    private func loadMoreData() {
        start += 30
        guard totalPage != start else { return }
        
        NetworkManager.shared.callRequest(text: searchText, start: start, buttonTag: buttonTag) { response in
            switch response {
            case .success(let value):
                self.outputList.value.append(contentsOf: value.items)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
}
