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
    
    func showAlert(title: String, message: String, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
            
        let check = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
            
        alert.addAction(cancel)
        alert.addAction(check)
            
        present(alert, animated: true)
    }
}
