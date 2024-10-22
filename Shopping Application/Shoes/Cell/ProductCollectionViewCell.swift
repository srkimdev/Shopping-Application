//
//  ProductCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 10/20/24.
//

import UIKit
import SnapKit

final class ProductCollectionViewCell: BaseCollectionViewCell {
    
    private let shoesImage = {
        let object = UIImageView()
        object.layer.cornerRadius = 10
        return object
    }()
    
    private let productNameLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 15)
        object.numberOfLines = 2
        return object
    }()
    
    private let priceLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 17, weight: .bold)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
    }
    
    override func configureHierarchy() {
        contentView.addSubview(shoesImage)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        shoesImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView).multipliedBy(0.7)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(shoesImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    func designCell(input: String) {
        shoesImage.image = UIImage(named: "launch")
        productNameLabel.text = "Nike Air Forcedddddddddddddddddddddddddddddd"
        priceLabel.text = "250"
    }
    
}
