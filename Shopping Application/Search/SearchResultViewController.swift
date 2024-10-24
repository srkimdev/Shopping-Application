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
        let object = UICollectionView(frame: .zero, collectionViewLayout: mainLayout())
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
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(24)
        }
        
        accurateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
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
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
    }

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
//        let transition = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)

        let vc = SearchWebViewController()
        vc.likeChange = { () in
            self.productCollectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        }
        
        vc.sendToast = { value in
            self.view.makeToast(value, position: .bottom)
        }
        
//        vc.data = transition
        transitionScreen(vc: vc, style: .push)
    }
    
    func goodButtonTapped(at index: Int) {
        viewModel.inputLikeButton.value = viewModel.outputList.value[index]
    }
    
}

extension SearchResultViewController {
    func mainLayout() -> UICollectionViewLayout {
        let fraction: CGFloat = 1.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction / 3.0), heightDimension: .fractionalHeight(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9 / 2.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
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

