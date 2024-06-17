//
//  ProfileSelectingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileSelectingViewController: UIViewController {

    let selectedImage = UIImageView()
    let selectedImageButton = UIButton()
    let cameraImageView = UIImageView()
    let cameraImage = UIImageView()
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var profileImage: UIImageView?
    var selectedNumber: Int = UserDefaults.standard.integer(forKey: "profileNumber")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ProfileSelectingCollectionViewCell.self, forCellWithReuseIdentifier: ProfileSelectingCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "fromWhere")
    }
    
    override func viewDidLayoutSubviews() {
        selectedImage.layer.cornerRadius = selectedImage.frame.width / 2
        cameraImageView.layer.cornerRadius = 10
    }
    
    func configureHierarchy() {
        
        view.addSubview(selectedImage)
        view.addSubview(selectedImageButton)
        selectedImageButton.addSubview(cameraImageView)
        cameraImageView.addSubview(cameraImage)
        view.addSubview(imageCollectionView)
        
    }
    
    func configureLayout() {
        
        selectedImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        selectedImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.equalTo(selectedImageButton.snp.trailing).offset(-4)
            make.bottom.equalTo(selectedImageButton.snp.bottom).offset(-12)
            make.height.width.equalTo(20)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(cameraImageView.snp.width).multipliedBy(0.7)
        }
        
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedImage.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
        
    }
    
    func configureUI() {
        
        let mode = UserDefaults.standard.string(forKey: "mode")
        
        if mode == "edit" {
            navigationItem.title = "EDIT PROFILE"
        } else {
            navigationItem.title = "PROFILE SETTING"
        }
        
        view.backgroundColor = .white
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = .black
        navigationItem.leftBarButtonItem = item
        
        selectedImage.image = UIImage(named: "profile_\(UserDefaults.standard.integer(forKey: "profileNumberTemp"))")
        selectedImage.layer.masksToBounds = true
        selectedImage.layer.borderWidth = 3
        selectedImage.layer.borderColor = CustomDesign.orange.cgColor
        
        cameraImageView.backgroundColor = CustomDesign.orange
        cameraImage.tintColor = .white
        cameraImage.image = UIImage(systemName: "camera.fill")
        
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileSelectingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileSelectingCollectionViewCell.identifier, for: indexPath) as! ProfileSelectingCollectionViewCell
        
        cell.designCell(transition: indexPath.row, num: selectedNumber)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImage.image = UIImage(named: "profile_\(indexPath.row)")
        
        selectedNumber = indexPath.row
        
        imageCollectionView.reloadData()
        
        UserDefaults.standard.set(selectedNumber, forKey: "profileNumberTemp")
    }
    
}

extension ProfileSelectingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 70
        
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return layout
    }
    
}
