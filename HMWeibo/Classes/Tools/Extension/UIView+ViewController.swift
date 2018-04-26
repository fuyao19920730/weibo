//
//  UIView+ViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/20.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

extension UIView {
    
    //查找视图对象的响应者链条中的 导航视图控制器
    func navController() -> UINavigationController? {
        
        //获取当前视图的下一个响应者
        var next = self.next
        //循环遍历下一个响应者的下一个响应者
        while next != nil {
            if let nav = next as? UINavigationController {
                return nav
            }
            
            //如果不是导航视图控制器  就继续查找
            next = next?.next
        }
        return nil
    }
    
}
