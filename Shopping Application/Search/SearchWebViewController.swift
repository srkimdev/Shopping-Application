//
//  SearchWebViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/15/24.
//

import UIKit
import WebKit
import SnapKit
import RealmSwift

final class SearchWebViewController: BaseViewController {

    var data: DBTable!
    
    let mainView = SearchWebView()
    
    let realm = try! Realm()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: data.link)!
        let request = URLRequest(url: url)
        mainView.website.load(request)
    }
    
    override func configureUI() {
        navigationItem.title = data.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        BackButton()
        
        if UserDefaults.standard.bool(forKey: data.productId) {
            let item = UIBarButtonItem(image: CustomDesign.likeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: CustomDesign.unlikeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }
    }
    
    @objc func likeButtonClicked() {
        
        var like = UserDefaults.standard.bool(forKey: data.productId)
        like.toggle()
        
        let task = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)
        
        if like {
            try! realm.write {
                realm.add(task)
                
                UserDefaults.standard.set(true, forKey: data.productId)
                
                print("Realm Add Succeed")
            }
        } else {
            
            let filter = realm.objects(DBTable.self).where{
                $0.productId == data.productId
            }
            
            try! realm.write {
                realm.delete(filter)
                
                UserDefaults.standard.set(false, forKey: data.productId)
                
                print("Realm Delete Succeed")
            }
        }

        if like {
            let item = UIBarButtonItem(image: CustomDesign.likeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        } else {
            let item = UIBarButtonItem(image: CustomDesign.unlikeImage, style: .plain, target: self, action: #selector(likeButtonClicked))
            navigationItem.rightBarButtonItem = item
        }
        
        UserDefaults.standard.set(like, forKey: data.productId)
    }
}


