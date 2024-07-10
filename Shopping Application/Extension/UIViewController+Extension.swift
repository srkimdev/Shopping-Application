//
//  UIViewController+Extension.swift
//  Shopping Application
//
//  Created by 김성률 on 7/10/24.
//

import UIKit

extension UIViewController {
    
    func BackButton() {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = CustomDesign.itemTintColor
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}
