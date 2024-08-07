//
//  SearchResultViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

final class SearchResultViewController: BaseViewController {

    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let line = UIView()
    let totalLabel = UILabel()
    let accurateButton = UIButton()
    let dateButton = UIButton()
    let priceUpButton = UIButton()
    let priceDownButton = UIButton()
    
    let realmrepository = RealmRepository()
    let realm = try! Realm()
    var data: String?
    
    let viewModel = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.prefetchDataSource = self

        productCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)

        guard let data = data else { return }
        viewModel.inputText.value = data
        
        view.makeToastActivity(.center)
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productCollectionView.reloadData()
    }

    override func configureHierarchy() {
        
        view.addSubview(line)
        view.addSubview(totalLabel)
        view.addSubview(accurateButton)
        view.addSubview(dateButton)
        view.addSubview(priceUpButton)
        view.addSubview(priceDownButton)
        view.addSubview(productCollectionView)
    }
    
    override func configureLayout() {
        
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(24)
        }
        
        accurateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(accurateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }
        
        priceUpButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        priceDownButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(priceUpButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accurateButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        
        navigationItem.title = data
        BackButton()
        
        line.backgroundColor = CustomDesign.lineColor
        
        totalLabel.textColor = CustomDesign.orange
        totalLabel.font = .boldSystemFont(ofSize: 15)
        
        let buttonArray = [accurateButton, dateButton, priceUpButton, priceDownButton]
        
        for item in 0...3 {
            buttonDesign(button: buttonArray[item], buttonName: ConstantTable.arrayButton[item])
            buttonArray[item].tag = item
        }
        
        accurateButton.backgroundColor = .black
        accurateButton.setTitleColor(.white, for: .normal)
    }
    
    override func configureAction() {
        accurateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        priceUpButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        priceDownButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
    }
    
    @objc func arrayButtonClicked(_ sender: UIButton) {
        
        viewModel.inputButton.value = sender.tag

        [accurateButton, dateButton, priceUpButton, priceDownButton].forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        let data = viewModel.outputList.value[sender.tag]
        var like = UserInfo.shared.getLikeProduct(forkey: data.productId)
        like.toggle()
        
        let task = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)
        
        if like {
            viewModel.inputLike.value = task
            
            UserInfo.shared.setLikeProduct(isLike: true, forkey: data.productId)
            
            print("Realm Add Succeed")
            
        } else {
            
            let filter = realm.objects(DBTable.self).first(where: {$0.productId == self.viewModel.outputList.value[sender.tag].productId} )
            
            viewModel.inputUnLike.value = filter!
            
            UserInfo.shared.setLikeProduct(isLike: false, forkey: data.productId)
            
            print("Realm Delete Succeed")
        }
        
        UIView.performWithoutAnimation {
            productCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil, userInfo: nil)
    }
    
    func bindData() {
        
        viewModel.outputCount.bind { [weak self] value in
            self?.totalLabel.text = "\(NumberFormatterManager.shared.Comma(value))개의 검색 결과"
            self?.view.hideToastActivity()
        }
    
        viewModel.outputScrollToTop.bind { [weak self] value in
            guard let value else { return }
            self?.productCollectionView.reloadData()
            self?.productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.outputPagination.bind { [weak self] value in
            guard let value else { return }
            self?.productCollectionView.reloadData()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(transition: viewModel.outputList.value[indexPath.row])
        
        cell.goodButton.tag = indexPath.row
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = viewModel.outputList.value[indexPath.item]
        let transition = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)

        let vc = SearchWebViewController()
        vc.likeChange = { () in
            self.productCollectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        }
        
        vc.sendToast = { value in
            self.view.makeToast(value, position: .bottom)
        }
        
        vc.data = transition
        transitionScreen(vc: vc, style: .push)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 68
        
        layout.itemSize = CGSize(width: width/2, height: 280)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 2, left: 14, bottom: 10, right: 14)
        
        return layout
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            if viewModel.outputList.value.count - 4 == item.row {
                viewModel.inputPage.value = ()
            }
        }
    }
}

extension SearchResultViewController {
    
    private func buttonDesign(button: UIButton, buttonName: String) {
        
        button.setTitle(buttonName, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 15
    }
}
