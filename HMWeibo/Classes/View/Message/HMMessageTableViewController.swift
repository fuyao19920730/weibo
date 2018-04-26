//
//  HMMessageTableViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMMessageTableViewController: HMVisitorTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        //设置访客视图信息
        if !userLogin {
            visitorView?.setVisitorInfo(tipText: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知", imageName: "visitordiscover_image_message")
            return
        }
        
        //设置导航条
        //CUICatalog: Invalid asset name supplied:  图片设置空字符串 就会报这个问题
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: nil, title: "发现群", target: self, action: #selector(findGroup))
        
        tabBarItem.badgeValue = "10"
        
//        setbadgeBackGround()
    }
    
    
    private func setbadgeBackGround() {
        //遍历 tabbar的子视图
        for subView in tabBarController!.tabBar.subviews {
            if subView.isKind(of:NSClassFromString("UITabBarButton")!) {
                for v in subView.subviews {
                    if v.isKind(of:NSClassFromString("_UIBadgeView")!) {
                        for bgView in v.subviews {
                            if bgView.isKind(of:NSClassFromString("_UIBadgeBackground")!) {
                                print("终于找到你,还好没放弃")
                                print(bgView)
                                //通过KVC 来设置成员变量  打断点  通过调试台查看 成员变量
                                bgView.setValue(UIImage(named: "main_badge"), forKey: "_image")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func findGroup() {
        print("发现群")
        //修改badgeValue
        tabBarItem.badgeValue = nil
        tabBarItem.badgeValue = "\(arc4random() % 50)"
        
    }

}
