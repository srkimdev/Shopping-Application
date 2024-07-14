//
//  SearchSaveCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 7/7/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchSaveCollectionViewCell: BaseCollectionViewCell {
    
    let productImage = UIImageView()
    let goodButton = UIButton()
    let companyLabel = UILabel()
    let productLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(productImage)
        productImage.addSubview(goodButton)
        contentView.addSubview(companyLabel)
        contentView.addSubview(productLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        
        productImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        goodButton.snp.makeConstraints { make in
            make.trailing.equalTo(productImage.snp.trailing).inset(12)
            make.bottom.equalTo(productImage.snp.bottom).inset(12)
            make.size.equalTo(24)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(10)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(16)
        }
    }
    
    override func configureUI() {
        
        productImage.layer.masksToBounds = true
        productImage.isUserInteractionEnabled = true
        productImage.layer.cornerRadius = 10
        
        goodButton.backgroundColor = .white
        goodButton.setImage(CustomDesign.likeImage, for: .normal)
        goodButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        goodButton.layer.masksToBounds = true
        goodButton.layer.cornerRadius = 5
        
        companyLabel.font = .systemFont(ofSize: 11)
        companyLabel.textColor = .lightGray
        
        productLabel.font = .systemFont(ofSize: 12)
        productLabel.numberOfLines = 2
        
        priceLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    func designCell(transition: DBTable) {
        
        let url = URL(string: transition.image)
        productImage.kf.setImage(with: url)
        
        companyLabel.text = transition.mallName
        productLabel.text = HTMLManager.shared.changeHTML(text: transition.title)
        priceLabel.text = "\(NumberFormatterManager.shared.Comma(Int(transition.lprice) ?? 0))원"
    }
}
