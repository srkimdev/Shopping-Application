//
//  SettingOtherTableViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import SnapKit

class SettingOtherTableViewCell: BaseTableViewCell {

    let listLabel = UILabel()
    let saveImage = UIImageView()
    let countLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        
    }

    override func configureHierarchy() {
        
        contentView.addSubview(listLabel)
        contentView.addSubview(saveImage)
        contentView.addSubview(countLabel)
        
    }
    
    override func configureLayout() {
        
        listLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(-20)
        }
        
        saveImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(countLabel.snp.leading).offset(-4)
        }
        
    }
    
    override func configureUI() {
        listLabel.font = .systemFont(ofSize: 13)
        countLabel.font = .systemFont(ofSize: 13)
    }
    
    func designCell(transition: String) {
        listLabel.text = transition
    }
    
}
