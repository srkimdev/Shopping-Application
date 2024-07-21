//
//  ProfileSettingViewModel.swift
//  Shopping Application
//
//  Created by 김성률 on 7/9/24.
//

import Foundation

final class ProfileSettingViewModel {
    
    var inputText: Observable<String?> = Observable("")
    var outputText: Observable<String?> = Observable("")
    
    var allowed = Observable(false)
    
    init() {
        inputText.bind { value in
            self.validation()
        }
    }
    
    private func validation() {
        
        guard let inputText = inputText.value else { return }
        
        if inputText.count < 2 || inputText.count >= 10 {
            outputText.value = "2글자 이상 10글자 미만으로 입력해주세요."
            allowed.value = false
        } else if inputText.contains("@") {
            outputText.value = "닉네임에 @는 포함할 수 없어요."
            allowed.value = false
        } else if inputText.contains("#") {
            outputText.value = "닉네임에 #는 포함할 수 없어요."
            allowed.value = false
        } else if inputText.contains("$") {
            outputText.value = "닉네임에 $는 포함할 수 없어요."
            allowed.value = false
        } else if inputText.contains("%") {
            outputText.value = "닉네임에 %는 포함할 수 없어요."
            allowed.value = false
        } else if isDigit(input: inputText) {
            outputText.value = "닉네임에 숫자는 포함할 수 없어요."
            allowed.value = false
        } else if inputText.contains(" ") {
            outputText.value = "닉네임에 공백은 포함할 수 없어요."
        } else {
            outputText.value = "사용할 수 있는 닉네임이에요"
            allowed.value = true
        }
    }
    
    private func isDigit(input: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        return input.rangeOfCharacter(from: decimalCharacters) != nil
    }
}
