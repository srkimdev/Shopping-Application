//
//  MainSearchViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/10/24.
//

import Foundation

final class MainSearchViewModel {
    
    var searchList: [String] = []
    
    var inputText: Observable<String> = Observable("")
    var deleteButtonTapped: Observable<Int> = Observable(-1)
    var deleteAllButtonTapped: Observable<Void> = Observable(())
    
    var reloadDataTrigger: Observable<Void> = Observable(())
//    var outputIsText: Observable<Bool> = Observable(false)
    
    init() {
        inputText
            .bind { [weak self] value in
                guard let self else { return }
                topToRecentSearch(search: value)
                reloadDataTrigger.value = ()
            }
        
        deleteButtonTapped
            .bind { [weak self] value in
                guard let self else { return }
                searchList.remove(at: value)
                reloadDataTrigger.value = ()
            }
        
        deleteAllButtonTapped
            .bind { [weak self] _ in
                guard let self else { return }
                searchList.removeAll()
                reloadDataTrigger.value = ()
            }
        
    }
    
//    private func validate() {
//        if inputIsText.value.count > 0 {
//            self.outputIsText.value = true
//        } else {
//            self.outputIsText.value = false
//        }
//    }
    private func topToRecentSearch(search: String) {
        if searchList.contains(search) {
            searchList.removeAll { $0 == search }
        }
        searchList.insert(search, at: 0)
    }
}
