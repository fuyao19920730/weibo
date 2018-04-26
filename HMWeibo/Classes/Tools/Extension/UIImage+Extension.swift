//
//  UIImage+Extension.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit


extension UIImage {
    //给当前屏幕截图
    class func snapshotScreen() -> UIImage {
        let window = UIApplication.shared.keyWindow!
        //开启图片上下文
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        //将window显示的内容画到上下文中
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        
        //从上下文中 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
}
