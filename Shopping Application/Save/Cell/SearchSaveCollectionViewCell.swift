//
//  SearchSaveCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 7/7/24.
//

import UIKit
import SnapKit

final class SearchSaveCollectionViewCell: BaseCollectionViewCell {
    
    private let background = {
        let object = UIView()
        object.layer.cornerRadius = 10
        return object
    }()
    
    private let productImage = {
        let object = UIImageView()
        object.layer.cornerRadius = 10
        return object
    }()
    
    private let productLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 17, weight: .bold)
        return object
    }()
    
    private let categoryLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 13)
        object.textColor = .gray
        return object
    }()
    
    private let priceLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 17, weight: .bold)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        contentView.addSubview(background)
        background.addSubview(productImage)
        background.addSubview(productLabel)
        background.addSubview(categoryLabel)
        background.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        productImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.width.equalTo(productImage.snp.height)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.top)
            make.leading.equalTo(productImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(8)
            make.leading.equalTo(productImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productImage.snp.bottom)
            make.leading.equalTo(productImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
    }
    
    func designCell(transition: DBTable) {
        
//        let url = URL(string: transition.image)
//        productImage.kf.setImage(with: url)
//        
//        companyLabel.text = transition.mallName
//        productLabel.text = HTMLManager.shared.changeHTML(text: transition.title)
//        priceLabel.text = "\(NumberFormatterManager.shared.Comma(Int(transition.lprice) ?? 0))원"
    }
}
