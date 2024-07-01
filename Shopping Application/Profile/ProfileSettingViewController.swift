//
//  ProfileSettingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: BaseViewController {

    let mainView = ProfileSettingView()
    
    var allowed: Bool = false
    var textFieldInput: String = "" {
        didSet {
            isNickname()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // from setting
        if UserDefaults.standard.bool(forKey: "fromWhere") {
            mainView.profileImage.image = UIImage(named: "profile_\(UserDefaults.standard.integer(forKey: "profileNumber"))")
            mainView.nicknameTextField.text = UserDefaults.standard.string(forKey: "userName")
        } else {
        // from onboarding
            mainView.profileImage.image = UIImage(named: "profile_\(UserDefaults.standard.integer(forKey: "profileNumberTemp"))")
        }
        
        if UserDefaults.standard.string(forKey: "mode") == "edit" {
            textFieldInput = UserDefaults.standard.string(forKey: "userName") ?? ""
        }

    }
    
    override func viewDidLayoutSubviews() {
        mainView.profileImage.layer.cornerRadius = mainView.profileImage.frame.size.width / 2
        mainView.cameraImageView.layer.cornerRadius = 10
    }
    
    override func configureUI() {
        
        // mode check
        if UserDefaults.standard.string(forKey: "mode") == "edit"{
            navigationItem.title = "EDIT PROFILE"
            let item = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
            item.tintColor = CustomDesign.itemTintColor
            navigationItem.rightBarButtonItem = item
            
            mainView.clearButton.isHidden = true

        } else {
            navigationItem.title = "PROFILE SETTING"
            randomImage()
        }
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = CustomDesign.itemTintColor
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func clearButtonClicked() {
        
        // you can go to next page and user information will be saved when allowed is true
        if allowed {
            
            // save - userName, mode, initial screen, joinDate, profileNumber
            UserDefaultsManager.userName = textFieldInput
            UserDefaultsManager.goToSearch = true
            UserDefaultsManager.joinDate = joinDate()
            UserDefaultsManager.profileNumber = UserDefaults.standard.integer(forKey: "profileNumberTemp")
            
            UserDefaults.standard.set(ProfileMode.edit.rawValue, forKey: "mode")
            
            // go to TabBarController
            let vc = TabBarController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true)
        }
    
    }
    
    // go back
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        textFieldInput = text
    }
    
    // go to profileSelecting when you click the profileImage
    @objc func profileImageButtonClicked() {
        let vc = ProfileSelectingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // savebutton in edit mode
    @objc func saveButtonClicked() {
        if allowed {
            UserDefaultsManager.userName = mainView.nicknameTextField.text!
            UserDefaultsManager.profileNumber = UserDefaults.standard.integer(forKey: "profileNumberTemp")
        }
    }

}

extension ProfileSettingViewController {
    
    // show randomImage
    private func randomImage() {
        let randomNumber: Int = .random(in: 0...ConstantTable.profileImageNumber.count - 1)
        mainView.profileImage.image = UIImage(named: "profile_\(randomNumber)")
        UserDefaults.standard.set(randomNumber, forKey: "profileNumberTemp")
    }
    
    // create joinDate
    private func joinDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: currentDate)
    }
    
    // check textfield has number or not
    private func isDigit(input: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        return input.rangeOfCharacter(from: decimalCharacters) != nil
    }
    
    // check textfield condition and set allowed
    private func isNickname() {
        
        if textFieldInput.count < 2 || textFieldInput.count >= 10 {
            mainView.nicknameStatusLable.text = "2글자 이상 10글자 미만으로 입력해주세요."
            allowed = false
        } else if textFieldInput.contains("@") {
            mainView.nicknameStatusLable.text = "닉네임에 @는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("#") {
            mainView.nicknameStatusLable.text = "닉네임에 #는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("$") {
            mainView.nicknameStatusLable.text = "닉네임에 $는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("%") {
            mainView.nicknameStatusLable.text = "닉네임에 %는 포함할 수 없어요."
            allowed = false
        } else if isDigit(input: textFieldInput) {
            mainView.nicknameStatusLable.text = "닉네임에 숫자는 포함할 수 없어요."
            allowed = false
        } else {
            mainView.nicknameStatusLable.text = "사용할 수 있는 닉네임이에요"
            allowed = true
        }
        
    }
    
}
