//
//  RecentProductCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 10/20/24.
//

import UIKit
import SnapKit

final class RecentProductCollectionViewCell: BaseCollectionViewCell {
    
    private let shoesImage = {
        let object = UIImageView()
        object.layer.cornerRadius = 10
        return object
    }()
    
    private let productNameLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.numberOfLines = 1
        return object
    }()
    
    private let priceLabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
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
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
//        productNameLabel.snp.makeConstraints { make in
//            make.top.equalTo(shoesImage.snp.bottom).offset(8)
//            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
//            make.height.equalTo(20)
//        }
//        
//        priceLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
//            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
//        }
    }
    
    func designCell(input: String) {
        shoesImage.image = UIImage(systemName: "star")
        productNameLabel.text = "Nike Air Forcedddddddddddddddddddddddddddddd"
        priceLabel.text = "250"
    }
    
}
