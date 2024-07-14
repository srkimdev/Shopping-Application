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
    var likeChange: (() -> Void)?
    
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
        
        let image = UserInfo.shared.getLikeProduct(forkey: data.productId) ? CustomDesign.likeImage : CustomDesign.unlikeImage
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func likeButtonClicked() {
        
        var like = UserInfo.shared.getLikeProduct(forkey: data.productId)
        like.toggle()
        
        let task = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)
        
        if like {
            try! realm.write {
                realm.add(task)
                
                UserInfo.shared.setLikeProduct(isLike: true, forkey: data.productId)
                
                print("Realm Add Succeed")
            }
        } else {
            
            let filter = realm.objects(DBTable.self).where{
                $0.productId == data.productId
            }
            
            try! realm.write {
                realm.delete(filter)
                
                UserInfo.shared.setLikeProduct(isLike: false, forkey: data.productId)
                
                print("Realm Delete Succeed")
            }
        }

        let image = UserInfo.shared.getLikeProduct(forkey: data.productId) ? CustomDesign.likeImage : CustomDesign.unlikeImage
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = item
        
        UserInfo.shared.setLikeProduct(isLike: like, forkey: data.productId)
        
        likeChange?()
        NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil, userInfo: nil)
    }
}


