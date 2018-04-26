//
//  UIView+IBInsepectable.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
//@IBInspectable 为视图在xib/或者sb中添加可视化的属性
// @IBDesignable 在一个 '自定义'视图中添加@IBDesignable 修饰 那么他的 IBInspectable修饰的属性可以实时显示

extension UIView {
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            //返回layer.cornerRadius
            return layer.cornerRadius
        }
        
        set {
            //设置 layer.cornerRadius
            layer.cornerRadius = newValue
            //设置 maskToBounds
            if newValue > 0 {
                layer.masksToBounds = true
            } else {
                layer.masksToBounds = false
            }
        }
    }
    
    
    
    //设置 borderWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }

        set {
            layer.borderWidth = newValue
        }

    }
    
    //颜色
    @IBInspectable var borderColor: UIColor? {
        get {
            if let c = layer.borderColor {
                return UIColor(cgColor: c)
            }
            return nil
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
        
    }
}
