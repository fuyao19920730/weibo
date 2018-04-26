//
//  HMTabbarItem.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMTabbarItem: UITabBarItem {
    
    //一旦外界修改 badgeValue  就要给当前的tabbarbutton badgeValue的修改背景视图
    override var badgeValue: String? {
    
    //获取item的 _target 对应的值
        didSet {
            let target = self.value(forKey: "_target") as! HMMainViewController
            for subView in target.tabBar.subviews {
                if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
                    for v in subView.subviews {
                        if v.isKind(of: NSClassFromString("_UIBadgeView")!) {
                            for bgView in v.subviews {
                                if bgView.isKind(of: NSClassFromString("_UIBadgeBackground")!) {
                                    print("终于找到你,还好没放弃")
//                                    print(bgView)
                                    //通过KVC 来设置成员变量  打断点  通过调试台查看 成员变量
                                    bgView.setValue(UIImage(named: "main_badge"), forKey: "_image")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
