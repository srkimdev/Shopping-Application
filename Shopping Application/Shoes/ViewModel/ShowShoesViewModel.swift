//
//  ShoesShowViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 10/22/24.
//

import Foundation

final class ShowShoesViewModel {
    
    var inputTrigger = Observable<Void>(())
    var inputBrand = Observable<BrandCategory>(.adidas)
    
    var outputBrandList = Observable<[SearchResultDetail]>([])
    var outputNewList = Observable<[SearchResultDetail]>([])
    
    init() {
        inputTrigger
            .bind { [weak self] _ in
                guard let self else { return }
                callAPI()
            }
        
        inputBrand
            .bind { [weak self] value in
                guard let self else { return }
                callBrand(brand: value)
            }
    }
    
    private func callAPI() {
        NetworkManager.shared.callRequest(text: BrandCategory.adidas.rawValue, start: 1, sort: Sorts.sim) { value in
            switch value {
            case .success(let value):
                let temp = value.items.filter { $0.mallName == "네이버" }
                self.outputBrandList.value = temp
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkManager.shared.callRequest(text: "신발", start: 1, sort: Sorts.sim) { value in
            switch value {
            case .success(let value):
                let temp = value.items.filter { $0.mallName == "네이버" }
                self.outputNewList.value = temp
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func callBrand(brand: BrandCategory) {
        NetworkManager.shared.callRequest(text: brand.rawValue, start: 1, sort: Sorts.date) { value in
            switch value {
            case .success(let value):
                let temp = value.items.filter { $0.mallName == "네이버" }
                self.outputNewList.value = temp
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
