//
//  HMDiscoverTableViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMDiscoverTableViewController: HMVisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if !userLogin {
            visitorView?.setVisitorInfo(tipText: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知", imageName: "visitordiscover_image_message")
            return
        }
        //设置访客视图信息
        
        setNavBar()
    }
    
    private func setNavBar() {
        
        navigationItem.titleView = HMDiscoverSearchView.loadSearchView()
    }

}
