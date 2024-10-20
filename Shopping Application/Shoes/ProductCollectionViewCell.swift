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
        object.backgroundColor = .orange
        return object
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        contentView.addSubview(shoesImage)
    }
    
    override func configureLayout() {
        shoesImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func designCell(input: String) {
        shoesImage.backgroundColor = .orange
    }
    
}
