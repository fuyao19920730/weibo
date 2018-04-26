//
//  HMBaseNavViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/8.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit


//第二个子视图控制器的返回的按钮的title是第一个控制器的title 以后所有的子视图控制器的title都是返回
//返回手势的解决

class HMBaseNavViewController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航条的背景图片
        navigationBar.setBackgroundImage(UIImage(named: "navbarbackimaeg"), for: .default)
        self.interactivePopGestureRecognizer?.delegate = self
    }

    
    //重写了不super
    //根视图控制器无法添加   -> UINavigationController(rootViewController:XXX)
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        print(childViewControllers.count)
        //设置viewController 的navgitem.left
        //获取控制器的title
        
        if childViewControllers.count > 0 {
            var backTitle = "返回"
            if childViewControllers.count == 1 {
                backTitle = childViewControllers.first?.title ?? ""
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_back_withtext", title: backTitle, target: self, action: "back")
            //隐藏底部tabbar
            viewController.hidesBottomBarWhenPushed = true
            //设置颜色  页面跳转的时候会有颜色切换 导致卡顿
            viewController.view.backgroundColor = UIColor.white
        }
        super.pushViewController(viewController, animated: animated)
//        print(childViewControllers.count)
    }

    
    @objc private func back() {
        self.popViewController(animated: true)
    }
    
    
    //手势将要开始的协议方法
    //协议方法返回值是 bool值 如果返回ture  就可以正常工作,如果返回false 手势就会失效
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("哈哈哈")
        return childViewControllers.count != 1
//        if childViewControllers.count == 1 {
//            return false
//        }
//        return true
    }
}
