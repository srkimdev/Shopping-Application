//
//  SearchResultCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    let productImage = UIImageView()
    let goodButton = UIButton()
    let companyLabel = UILabel()
    let productLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
        contentView.addSubview(productImage)
        productImage.addSubview(goodButton)
        contentView.addSubview(companyLabel)
        contentView.addSubview(productLabel)
        contentView.addSubview(priceLabel)
        
    }
    
    func configureLayout() {
        
        productImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(200)
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
    
    func configureUI() {
        
        productImage.backgroundColor = .blue
        productImage.layer.masksToBounds = true
        productImage.layer.cornerRadius = 10
        
        companyLabel.font = .systemFont(ofSize: 11)
        companyLabel.textColor = .lightGray
        
        productLabel.font = .systemFont(ofSize: 12)
        productLabel.numberOfLines = 2
        
        priceLabel.font = .boldSystemFont(ofSize: 14)
        
        
        
    }
    
    func designCell(transition: SearchResultDetail) {
        
        let url = URL(string: transition.image)
        productImage.kf.setImage(with: url)
        
        companyLabel.text = transition.mallName
        productLabel.text = transition.title
        priceLabel.text = "\(transition.lprice)원"
        
        
    }
}
