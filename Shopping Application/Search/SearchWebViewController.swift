//
//  SearchWebViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import WebKit
import SnapKit

class SearchWebViewController: BaseViewController {

    var data: WebViewInfo
    
    let mainView = SearchWebView()
   
    init(data: WebViewInfo) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: data.text)!
        let request = URLRequest(url: url)
        mainView.website.load(request)
    }
    
    override func configureUI() {
        navigationItem.title = data.titlelabel.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        if UserDefaults.standard.bool(forKey: data.key) {
            let item = UIBarButtonItem(image: CustomDesign.likeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: CustomDesign.unlikeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }
    }
    
    @objc func likeButtonClicked() {
        
        // same with searchResultViewController.likeButtonClicked
        var like: Bool = UserDefaults.standard.bool(forKey: data.key)
        like.toggle()
        
        ConstantTable.likeCount = UserDefaultsManager.totalLike
        
        if like {
            ConstantTable.likeCount += 1
        } else {
            ConstantTable.likeCount -= 1
        }
        
        UserDefaultsManager.totalLike = ConstantTable.likeCount

        if like {
            let item = UIBarButtonItem(image: CustomDesign.likeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: CustomDesign.unlikeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }
        
        UserDefaults.standard.set(like, forKey: data.key)
    }
}


