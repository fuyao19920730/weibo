//
//  UIBarButtonItem+Extension.swift
//  HMWeibo
//
//  Created by heima on 16/4/8.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit


//Designated 专门设计的构造函数   -> 指定的构造函数
//指定的构造函数 和 存储性的属性 都不能够在扩展中声明
extension UIBarButtonItem {
    
    //构造函数
    convenience init(imageName: String? = nil,title: String? = nil,target: AnyObject?, action: Selector) {
        self.init()
        let btn = UIButton()
        //给按钮添加点击事件
        btn.addTarget(target, action: action, for: .touchUpInside)
        //设置图片
        if let img = imageName{
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            btn.setImage(UIImage(named: img), for: .normal)
            btn.setImage(UIImage(named: img + "_highlighted"), for: .highlighted)
        }
        //设置文字大小
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        //设置颜色
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        //设置大小和内容的大小一致
        btn.sizeToFit()
        //设置自定义视图
        customView = btn
    }
    
}
