//
//  MainSearchTableViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import SnapKit

final class MainSearchTableViewCell: BaseTableViewCell {

    let timeImage = UIImageView()
    let productLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        [timeImage, productLabel, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
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
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(deleteButton.snp.height).multipliedBy(1.0)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    override func configureUI() {
        timeImage.image = UIImage(systemName: "clock")
        timeImage.tintColor = CustomDesign.itemTintColor
        
        productLabel.font = .systemFont(ofSize: 13)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = CustomDesign.itemTintColor
    }
    
    func designCell(transition: String) {
        productLabel.text = transition
    }
}
