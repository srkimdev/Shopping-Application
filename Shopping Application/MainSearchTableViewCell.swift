//
//  MainSearchTableViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import SnapKit

class MainSearchTableViewCell: UITableViewCell {

    let timeImage = UIImageView()
    let productLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
        contentView.addSubview(timeImage)
        contentView.addSubview(productLabel)
        contentView.addSubview(deleteButton)
        
    }
    
    func configureLayout() {
        
        timeImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.width.equalTo(timeImage.snp.height).multipliedBy(1.0)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        productLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(timeImage.snp.trailing).offset(12)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(14)
            make.width.equalTo(deleteButton.snp.height).multipliedBy(1.0)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
    func configureUI() {
        
        timeImage.image = UIImage(systemName: "clock")
        timeImage.tintColor = .black
        
        print(timeImage.frame)
        print(deleteButton.frame)
        
        productLabel.text = "맥북 거치대"
        productLabel.font = .systemFont(ofSize: 13)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .black
        
    }
    
    
    
}
