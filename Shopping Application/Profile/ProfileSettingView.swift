//
//  ProfileSettingView.swift
//  Shopping Application
//
//  Created by 김성률 on 6/30/24.
//

import UIKit
import SnapKit

final class ProfileSettingView: BaseView {
    
    let profileImage = UIImageView()
    let profileImageButton = UIButton()
    let cameraImageView = UIImageView()
    let cameraImage = UIImageView()
    let nicknameTextField = UITextField()
    let textFieldLine = UIView()
    let nicknameStatusLable = UILabel()
    let clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        addSubview(profileImage)
        addSubview(profileImageButton)
        profileImageButton.addSubview(cameraImageView)
        cameraImageView.addSubview(cameraImage)
        addSubview(nicknameTextField)
        addSubview(textFieldLine)
        addSubview(nicknameStatusLable)
        addSubview(clearButton)
    }
    
    override func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self)
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
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(30)
        }
        
        textFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.height.equalTo(1)
        }
        
        nicknameStatusLable.snp.makeConstraints { make in
            make.top.equalTo(textFieldLine.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(24)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLable.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
    }
    
    override func configureUI() {
        
        backgroundColor = CustomDesign.viewBackgoundColor
        
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
    
}
