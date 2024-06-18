//
//  ProfileSelectingCollectionViewCell.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileSelectingCollectionViewCell: UICollectionViewCell {
    
    let profileImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
    }
    
    func configureHierarchy() {
        
        contentView.addSubview(profileImage)
        
    }
    
    func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = CustomDesign.profileBorderWidth1
        profileImage.contentMode = .scaleAspectFill
        profileImage.alpha = 0.5
    }
    
    func designCell(transition: Int, num: Int) {
        profileImage.image = UIImage(named: "profile_\(transition)")
        
        print(transition, num)
        if transition == num {
            print("here")
            profileImage.layer.borderColor = CustomDesign.orange.cgColor
            profileImage.alpha = 1
        } else {
            profileImage.layer.borderColor = UIColor.black.cgColor
            profileImage.alpha = 0.5
        }
    }
    
    
}
