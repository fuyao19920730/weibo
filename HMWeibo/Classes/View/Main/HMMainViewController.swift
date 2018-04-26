//
//  HMMainViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMMainViewController: UITabBarController {
    
    
    @objc private func plusBtnDidClick() {
        print("撰写按钮被点击啦")
        //添加到window上
        let composeView = HMComposeView()
        
        composeView.show(target: self)
//        UIApplication.sharedApplication().keyWindow?.addSubview(composeView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //自定义tabbar
        let mainTabbar = HMMainTabbar()
        
        mainTabbar.plusBtn.addTarget(self, action: #selector(plusBtnDidClick), for: .touchUpInside)
        //使用 KVC
        print(tabBar.classForCoder)
        setValue(mainTabbar, forKey: "tabBar")
        print(tabBar.classForCoder)

        addChildViewControllers()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: 添加子视图控制器
    //private  只有在 '当前文件内' 才可以访问该方法
    private func addChildViewControllers() {
        addChildViewCOntroller(vc: HMHomeTableViewController(), title: "首页", imageName: "tabbar_home", index: 0)
        addChildViewCOntroller(vc: HMMessageTableViewController(), title: "消息", imageName: "tabbar_message_center",index: 1)
        addChildViewCOntroller(vc: HMDiscoverTableViewController(), title: "发现", imageName: "tabbar_discover",index: 2)
        addChildViewCOntroller(vc: HMProfileTableViewController(), title: "我", imageName: "tabbar_profile",index: 3)
    }
    
    
    private func addChildViewCOntroller(vc: UIViewController, title: String, imageName: String, index: Int) {
        //设置tabbaritem的title
        //导航条的title 和tabbaritem的title显示不一样时候 可以使用这种方式
//        vc.tabBarItem.title = title
//        vc.navigationItem.title = title
        vc.tabBarItem = HMTabbarItem()
        vc.title = title
        vc.tabBarItem.tag = baseTag + index
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: .selected)
//        tabBar.tintColor = UIColor.orangeColor()
        let nav = HMBaseNavViewController(rootViewController: vc)
        addChildViewController(nav)
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(item.tag)
        var index = 0
        //一旦要是实现的 要学会使用视图层次查看器 来查找子视图
        for subView in tabBar.subviews {
            if subView.isKind(of:NSClassFromString("UITabBarButton")!) {
                if index == item.tag - baseTag {
                    //可以定位到点击的 UITabBarButton
                    //遍历UITabBarButton子视图
                    for v in subView.subviews {
                        if v.isKind(of:NSClassFromString("UITabBarSwappableImageView")!) {
//                            print(v)
                            //执行动画效果
                            v.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 2, options: [], animations: { () -> Void in
                                //先缩小 再放大
                                v.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                }, completion: { (_) -> Void in
                                    print("OK")
                            })
                        }
                    }
                }
                index = index + 1
            }
        }
    }

}
