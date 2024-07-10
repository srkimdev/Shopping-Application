//
//  MainSearchViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/10/24.
//

import Foundation

class MainSearchViewModel {
    
    var inputIsText: Observable<[String]> = Observable([])
    var outputIsText: Observable<Bool> = Observable(false)
    
    init() {
        inputIsText.bind { _ in
            self.validate()
        }
    }
    
    private func validate() {
        
        if inputIsText.value.count > 0 {
            self.outputIsText.value = true
        } else {
            self.outputIsText.value = false
        }
    }
}
