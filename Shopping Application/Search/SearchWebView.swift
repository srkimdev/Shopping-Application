//
//  SearchWebView.swift
//  Shopping Application
//
//  Created by 김성률 on 6/30/24.
//

import UIKit
import SnapKit
import WebKit

final class SearchWebView: BaseView {
    
    let website = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        addSubview(website)
    }
    
    override func configureLayout() {
        website.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
