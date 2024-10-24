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
        object.isUserInteractionEnabled = true
        return object
    }()
    
    private let likeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .red
        configuration.baseBackgroundColor = .clear
        
        let heartImage = UIImage(systemName: "heart")
        configuration.image = heartImage
        configuration.imagePadding = 8
        
        let button = UIButton(configuration: configuration)
        
        return button
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
        productImage.addSubview(likeButton)
        contentView.addSubview(productLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
        productImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(productImage.snp.width).multipliedBy(1.2)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(productImage.snp.trailing).inset(12)
            make.top.equalTo(productImage.snp.top).offset(12)
            make.size.equalTo(24)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(16)
        }
    }
    
    @objc private func goodButtonTapped() {
        if let delegate = delegate {
            delegate.goodButtonTapped(at: likeButton.tag)
        }
    }
    
    func designCell(transition: SearchResultDetail, index: Int) {
        
        productImage.setImage(transition.image)
        likeButton.tag = index
        
        productLabel.text = HTMLManager.shared.changeHTML(text: transition.title)
        priceLabel.text = "\(NumberFormatterManager.shared.Comma(Int(transition.lprice) ?? 0))원"
        
        let key = transition.productId
        
//        if UserInfo.shared.getLikeProduct(forkey: key) {
//            goodButton.backgroundColor = .white
//            goodButton.alpha = 1
//            goodButton.setImage(CustomDesign.likeImage, for: .normal)
//        } else {
//            goodButton.backgroundColor = .black
//            goodButton.alpha = 0.3
//            goodButton.setImage(CustomDesign.unlikeImage, for: .normal)
//        }
    }
}
