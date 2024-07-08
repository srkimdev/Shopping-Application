//
//  FolderTableViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 7/8/24.
//

import UIKit
import SnapKit

class FolderTableViewCell: BaseTableViewCell {

    let frontImage = UIImageView()
    var folderName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    override func configureHierarchy() {
        contentView.addSubview(frontImage)
        contentView.addSubview(folderName)
    }
    
    override func configureLayout() {
        
        frontImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(24)
        }
        
        folderName.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(frontImage.snp.trailing).offset(12)
        }
    }
    
    override func configureUI() {
        frontImage.image = UIImage(systemName: "heart.fill")
        frontImage.tintColor = .red
    }
    
}
