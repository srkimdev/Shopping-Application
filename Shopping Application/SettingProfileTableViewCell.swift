//
//  SettingProfileTableViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import SnapKit

class SettingProfileTableViewCell: UITableViewCell {

    let profileImage = UIImageView()
    let profileName = UILabel()
    let joinDate = UILabel()
    
    let nextButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImage)
        contentView.addSubview(profileName)
        contentView.addSubview(joinDate)
        contentView.addSubview(nextButton)
        
    }
    
    func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(24)
            make.width.equalTo(profileImage.snp.height).multipliedBy(1.0)
        }
        
        profileName.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(16)
        }
        
        joinDate.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom).offset(8)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
    func configureUI() {
        
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        
        profileName.font = .boldSystemFont(ofSize: 17)
        
        joinDate.text = "2024. 06. 15 가입"
        joinDate.font = .systemFont(ofSize: 12)
        
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.tintColor = .gray
        
    }
    
}

