//
//  ProfileSettingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: BaseViewController {

    let profileImage = UIImageView()
    let profileImageButton = UIButton()
    let cameraImageView = UIImageView()
    let cameraImage = UIImageView()
    let nicknameTextField = UITextField()
    let textFieldLine = UIView()
    let nicknameStatusLable = UILabel()
    let clearButton = UIButton()

    var allowed: Bool = false
    var textFieldInput: String = "" {
        didSet {
            isNickname()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // from setting
        if UserDefaults.standard.bool(forKey: "fromWhere") {
            profileImage.image = UIImage(named: "profile_\(UserDefaults.standard.integer(forKey: "profileNumber"))")
            nicknameTextField.text = UserDefaults.standard.string(forKey: "userName")
        } else {
        // from onboarding
            profileImage.image = UIImage(named: "profile_\(UserDefaults.standard.integer(forKey: "profileNumberTemp"))")
        }
        
        textFieldInput = UserDefaults.standard.string(forKey: "userName") ?? ""

    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        cameraImageView.layer.cornerRadius = 10
    }
    
    override func configureHierarchy() {
        
        view.addSubview(profileImage)
        view.addSubview(profileImageButton)
        profileImageButton.addSubview(cameraImageView)
        cameraImageView.addSubview(cameraImage)
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldLine)
        view.addSubview(nicknameStatusLable)
        view.addSubview(clearButton)
        
    }
    
    override func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImage.snp.trailing).offset(-4)
            make.bottom.equalTo(profileImage.snp.bottom).offset(-12)
            make.height.width.equalTo(20)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(cameraImageView.snp.width).multipliedBy(0.7)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(30)
        }
        
        textFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(1)
        }
        
        nicknameStatusLable.snp.makeConstraints { make in
            make.top.equalTo(textFieldLine.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(24)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLable.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
    }
    
    override func configureUI() {
        
        // mode check
        if UserDefaults.standard.string(forKey: "mode") == "edit"{
            navigationItem.title = "EDIT PROFILE"
            let item = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
            item.tintColor = CustomDesign.itemTintColor
            navigationItem.rightBarButtonItem = item
            
            clearButton.isHidden = true

        } else {
            navigationItem.title = "PROFILE SETTING"
            randomImage()
        }
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = CustomDesign.itemTintColor
        navigationItem.leftBarButtonItem = item
        
        view.backgroundColor = CustomDesign.viewBackgoundColor
        
        profileImage.layer.borderWidth = CustomDesign.profileBorderWidth3
        profileImage.layer.borderColor = CustomDesign.orange.cgColor
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        cameraImageView.backgroundColor = CustomDesign.orange
        cameraImageView.layer.masksToBounds = true
        cameraImageView.contentMode = .scaleAspectFill
        
        cameraImage.image = UIImage(systemName: "camera.fill")
        cameraImage.tintColor = .white
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        
        textFieldLine.backgroundColor = .systemGray4
        
        nicknameStatusLable.text = "2글자 이상 10글자 미만으로 입력해주세요."
        nicknameStatusLable.textColor = CustomDesign.orange
        nicknameStatusLable.font = .boldSystemFont(ofSize: 13)
        
        clearButton.setTitle("완료", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        clearButton.backgroundColor = CustomDesign.orange
        clearButton.layer.masksToBounds = true
        clearButton.layer.cornerRadius = 20
        
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
            UserDefaultsManager.userName = nicknameTextField.text!
            UserDefaultsManager.profileNumber = UserDefaults.standard.integer(forKey: "profileNumberTemp")
        }
    }

}

extension ProfileSettingViewController {
    
    // show randomImage
    func randomImage() {
        let randomNumber: Int = .random(in: 0...ConstantTable.profileImageNumber.count - 1)
        profileImage.image = UIImage(named: "profile_\(randomNumber)")
        UserDefaults.standard.set(randomNumber, forKey: "profileNumberTemp")
    }
    
    // create joinDate
    func joinDate() -> String {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: currentDate)

    }
    
    // check textfield has number or not
    func isDigit(input: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        return input.rangeOfCharacter(from: decimalCharacters) != nil
    }
    
    // check textfield condition and set allowed
    func isNickname() {
        
        if textFieldInput.count < 2 || textFieldInput.count >= 10 {
            nicknameStatusLable.text = "2글자 이상 10글자 미만으로 입력해주세요."
            allowed = false
        } else if textFieldInput.contains("@") {
            nicknameStatusLable.text = "닉네임에 @는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("#") {
            nicknameStatusLable.text = "닉네임에 #는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("$") {
            nicknameStatusLable.text = "닉네임에 $는 포함할 수 없어요."
            allowed = false
        } else if textFieldInput.contains("%") {
            nicknameStatusLable.text = "닉네임에 %는 포함할 수 없어요."
            allowed = false
        } else if isDigit(input: textFieldInput) {
            nicknameStatusLable.text = "닉네임에 숫자는 포함할 수 없어요."
            allowed = false
        } else {
            nicknameStatusLable.text = "사용할 수 있는 닉네임이에요"
            allowed = true
        }
        
    }
    
}
