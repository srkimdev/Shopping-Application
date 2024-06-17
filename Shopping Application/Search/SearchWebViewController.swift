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
    var text: String?
    var titleLabel: String?
    var key: String?
    var likeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        
        let url = URL(string: text!)!
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
        navigationItem.title = titleLabel?.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        
        guard let key = key else { return }
        
        if UserDefaults.standard.bool(forKey: key) {
            let item = UIBarButtonItem(image: UIImage(named: "like_selected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            item.tintColor = .black
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: UIImage(named: "like_unselected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }

    }
    
    @objc func likeButtonClicked() {
        
        guard let key = key else { return }
        var like: Bool = UserDefaults.standard.bool(forKey: key)
        like.toggle()
        
        likeCount = UserDefaults.standard.integer(forKey: "totalLike")
        
        if like {
            likeCount += 1
        } else {
            likeCount -= 1
        }
        
        UserDefaults.standard.set(likeCount, forKey: "totalLike")

        if like {
            let item = UIBarButtonItem(image: UIImage(named: "like_selected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: UIImage(named: "like_unselected"), style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
            
        }
        
        UserDefaults.standard.set(like, forKey: key)
    }
}


