//
//  SearchResultCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher

protocol SearchResultCellDelegate: AnyObject {
    func goodButtonTapped(at index: Int)
}

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    private let productImage: UIImageView = {
        let object = UIImageView()
        object.layer.masksToBounds = true
        object.isUserInteractionEnabled = true
        object.layer.cornerRadius = 10
        return object
    }()
    
    let goodButton: UIButton = {
        let object = UIButton()
        object.addTarget(self, action: #selector(goodButtonTapped), for: .touchUpInside)
        object.setImage(CustomDesign.unlikeImage, for: .normal)
        object.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        object.layer.masksToBounds = true
        object.layer.cornerRadius = 5
        return object
    }()
    
    private let companyLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 11)
        object.textColor = .lightGray
        return object
    }()
    
    private let productLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 12)
        object.numberOfLines = 2
        return object
    }()
    
    private let priceLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 14)
        return object
    }()
    
    weak var delegate: SearchResultCellDelegate?
    
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
    
    @objc private func goodButtonTapped() {
        if let delegate = delegate {
            delegate.goodButtonTapped(at: goodButton.tag)
        }
    }
    
    func designCell(transition: SearchResultDetail, index: Int) {
        
        productImage.setImage(transition.image)
        goodButton.tag = index
        
        companyLabel.text = transition.mallName
        productLabel.text = HTMLManager.shared.changeHTML(text: transition.title)
        priceLabel.text = "\(NumberFormatterManager.shared.Comma(Int(transition.lprice) ?? 0))원"
        
        let key = transition.productId
        
        if UserInfo.shared.getLikeProduct(forkey: key) {
            goodButton.backgroundColor = .white
            goodButton.alpha = 1
            goodButton.setImage(CustomDesign.likeImage, for: .normal)
        } else {
            goodButton.backgroundColor = .black
            goodButton.alpha = 0.3
            goodButton.setImage(CustomDesign.unlikeImage, for: .normal)
        }
    }
}
