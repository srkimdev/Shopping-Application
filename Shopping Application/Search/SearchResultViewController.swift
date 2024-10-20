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

    private lazy var productCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        object.delegate = self
        object.dataSource = self
        object.prefetchDataSource = self
        object.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        return object
    }()
    
    private let line: UIView = {
        let object = UIView()
        object.backgroundColor = CustomDesign.lineColor
        return object
    }()
    
    private let totalLabel: UILabel = {
        let object = UILabel()
        object.textColor = CustomDesign.orange
        object.font = .boldSystemFont(ofSize: 15)
        return object
    }()
    
    private let accurateButton: UIButton = {
        let object = FilterButton(text: "정확도")
        object.tag = 0
        return object
    }()
    
    private let dateButton: UIButton = {
        let object = FilterButton(text: "날짜순")
        object.tag = 1
        return object
    }()
    
    private let highPriceButton: UIButton = {
        let object = FilterButton(text: "가격높은순")
        object.tag = 2
        return object
    }()
    
    private let lowPriceButton: UIButton = {
        let object = FilterButton(text: "가격낮은순")
        object.tag = 3
        return object
    }()
    
    private let realmrepository = RealmRepository()
    private var viewModel: SearchResultViewModel
    
    init(_ viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.callAPI.value = ()
        view.makeToastActivity(.center)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        productCollectionView.reloadData()
//    }

    override func configureHierarchy() {
        view.addSubview(line)
        view.addSubview(totalLabel)
        view.addSubview(accurateButton)
        view.addSubview(dateButton)
        view.addSubview(highPriceButton)
        view.addSubview(lowPriceButton)
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
            make.width.equalTo(65)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(accurateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(65)
        }
        
        highPriceButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(85)
        }
        
        lowPriceButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(highPriceButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(85)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accurateButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = viewModel.searchText
        BackButton()
    }
    
    override func configureAction() {
        accurateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        highPriceButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        lowPriceButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
    }
    
    override func bind() {
        viewModel.outputCount
            .bind { [weak self] value in
                guard let self else { return }
                totalLabel.text = "\(NumberFormatterManager.shared.Comma(value))개의 검색 결과"
                view.hideToastActivity()
            }
    
        viewModel.outputScrollToTop
            .bind { [weak self] _ in
                guard let self else { return }
                productCollectionView.reloadData()
                productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        
        viewModel.outputPagination
            .bind { [weak self] _ in
                guard let self else { return }
                productCollectionView.reloadData()
            }
    }
    
    @objc func arrayButtonClicked(_ sender: UIButton) {
        
        viewModel.inputButton.value = sender.tag

//        [accurateButton, dateButton, priceUpButton, priceDownButton].forEach { button in
//            button.backgroundColor = .white
//            button.setTitleColor(.black, for: .normal)
//        }
//        sender.backgroundColor = .black
//        sender.setTitleColor(.white, for: .normal)
    }
    
//    @objc func likeButtonClicked(sender: UIButton) {
//        
//        let data = viewModel.outputList.value[sender.tag]
//        var like = UserInfo.shared.getLikeProduct(forkey: data.productId)
//        like.toggle()
//        
//        let task = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)
//        
//        if like {
//            viewModel.inputLike.value = task
//             
//            UserInfo.shared.setLikeProduct(isLike: true, forkey: data.productId)
//            
//            print("Realm Add Succeed")
//            
//        } else {
//            
//            let filter = realm.objects(DBTable.self).first(where: {$0.productId == self.viewModel.outputList.value[sender.tag].productId} )
//            
//            viewModel.inputUnLike.value = filter!
//            
//            UserInfo.shared.setLikeProduct(isLike: false, forkey: data.productId)
//            
//            print("Realm Delete Succeed")
//        }
//        
//        UIView.performWithoutAnimation {
//            productCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
//        }
//        
//        NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil, userInfo: nil)
//    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, SearchResultCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.designCell(transition: viewModel.outputList.value[indexPath.row], index: indexPath.row)
        
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
    
    func goodButtonTapped(at index: Int) {
        print(index)
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
                viewModel.inputPagination.value = ()
            }
        }
    }
}

