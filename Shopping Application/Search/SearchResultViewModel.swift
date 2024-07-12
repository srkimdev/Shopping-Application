//
//  SearchResultViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/12/24.
//

import Foundation

class SearchResultViewModel {
    
    var inputText: Observable<String?> = Observable(nil)
    var inputButton: Observable<Int?> = Observable(nil)
    var inputPage: Observable<Void?> = Observable(nil)
    
    var outputList: Observable<[SearchResultDetail]> = Observable([])
    var outputCount: Observable<Int> = Observable(0)
    
    var userInfo = UserInformation.shared
    var buttonTag: Int = 0
    var totalPage = 0
    var start = 0
    
    init() {
        
        inputText.bind { text in
            guard let text else { return }
            
            self.buttonTag = 0
            self.start = 1
            
            APIManager.shared.callRequest(text: text, start: self.start, buttonTag: self.buttonTag) { value in
                self.outputList.value = value.items
                self.outputCount.value = value.total
                self.totalPage = value.total
            }
        }
        
        inputButton.bind { value in
            guard let value else { return }
            
            self.buttonTag = value
            self.start = 1
            
            APIManager.shared.callRequest(text: self.userInfo.getRecentSearchText(), start: self.start, buttonTag: self.buttonTag) { value in
                self.outputList.value = value.items
            }
        }
        
        inputPage.bind { value in
            guard let value else { return }
            
            self.start += 30
        
            if self.totalPage != self.start {
                APIManager.shared.callRequest(text: self.userInfo.getRecentSearchText(), start: self.start, buttonTag: self.buttonTag) { value in
                    self.outputList.value.append(contentsOf: value.items)
                }
            }
        }
    }
}
