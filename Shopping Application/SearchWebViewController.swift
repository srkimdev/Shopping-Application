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
        navigationItem.title = titleLabel
    }
}


