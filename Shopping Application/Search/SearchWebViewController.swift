//
//  SearchWebViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import WebKit
import SnapKit

class SearchWebViewController: UIViewController {

    let website = WKWebView()
    var data: WebViewInfo
   
    init(data: WebViewInfo) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        
        let url = URL(string: data.text)!
        let request = URLRequest(url: url)
        website.load(request)
        
    }
    
    func configureHierarchy() {
        
        view.addSubview(website)
        
    }
    
    func configureLayout() {
        
        website.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

    func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = data.titlelabel.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        if UserDefaults.standard.bool(forKey: data.key) {
            let item = UIBarButtonItem(image: CustomDesign.likeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            item.tintColor = .black
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: CustomDesign.unlikeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }

    }
    
    @objc func likeButtonClicked() {
        
        var like: Bool = UserDefaults.standard.bool(forKey: data.key)
        like.toggle()
        
        ConstantTable.likeCount = UserDefaults.standard.integer(forKey: "totalLike")
        
        if like {
            ConstantTable.likeCount += 1
        } else {
            ConstantTable.likeCount -= 1
        }
        
        UserDefaults.standard.set(ConstantTable.likeCount, forKey: "totalLike")

        if like {
            let item = UIBarButtonItem(image: UIImage(named: "like_selected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: UIImage(named: "like_unselected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
            
        }
        
        UserDefaults.standard.set(like, forKey: data.key)
    }
}


