//
//  CommanTools.swift
//  HMWeibo
//
//  Created by heima on 16/4/9.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

//全局变量
let client_id = "170499311"
let redirect_uri = "http://www.baidu.com"
let client_secret = "057175dbb558f5153c319c9829dcd2e9"

let ScreenHeight = UIScreen.main.bounds.height
let ScreenWidth = UIScreen.main.bounds.width

//全局的日期格式化对象
let sharedDF = DateFormatter()


//定义全局baseTag
let baseTag = 1000
//定义通知的名称
//通知的使用场景
//1.一对多的情况下可以使用通知
//2.页面之间没有任何关联  但是为了完成两个类之间的通讯  可以使用通知
//3.视图层次出现了多层嵌套 为了获取用户点击事件  可以使用通知 (有简单的方式可以解决这个场景)
let HMSwitchRootViewController = "HMSwitchRootViewController"


//全局统一错误提示
let AppErrorTip = "世界上最遥远的距离是没有网络"


//随机色
//func randomColor() -> UIColor {
//    let r = CGFloat(arc4random() % 256) / 255
//    let g = CGFloat(arc4random() % 256) / 255
//    let b = CGFloat(arc4random() % 256) / 255
//    return UIColor(red: r, green: g, blue: b, alpha: 1)
//}


var randomColors: UIColor {
    let r = CGFloat(arc4random() % 256) / 255
    let g = CGFloat(arc4random() % 256) / 255
    let b = CGFloat(arc4random() % 256) / 255
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}

