//
//  HMDiscoverSearchView.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

/*
ScaleToFill         放大或者缩小进行填充
ScaleAspectFit
case ScaleAspectFill  工作中一般使用的最多还是这种方式
*/

class HMDiscoverSearchView: UIView {

    
    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    //右边的约束对象
    @IBOutlet weak var rightCons: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        //设置大小
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.height)
        
        //设置leftView
        self.textView.leftView = UIImageView(image: UIImage(named: "searchbar_textfield_search_icon"))
        self.textView.leftView?.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        //设置图片显示模式
        self.textView.leftView?.contentMode = .center
        //需要设置leftView为始终显示
        self.textView.leftViewMode = .always
        
        
        
        //设置输入框为原件
//        textView.layer.cornerRadius = 8
//        textView.layer.masksToBounds = true
    }
    //类方法 
    class func loadSearchView() -> HMDiscoverSearchView {
        let v = Bundle.main.loadNibNamed("HMDiscoverSearchView", owner: nil, options: nil)?.last as! HMDiscoverSearchView
        return v
    }
    
    
    
    
    //自动布局的东湖执行
    //1. 修改约束
    //2. 在动画闭包中强制刷新页面
    @IBAction func beginEdit(sender: AnyObject) {
        //先修改约束
        //系统 只是收集了约束的变化  会在layoutSubViews方法中去更新页面
        rightCons.constant = cancelBtn.frame.width
        //在动画闭包中 执行 强制刷新页面
//        //系统默认的动画时间 0.25
//        UIView.animateWithDuration(0.25) { () -> Void in
//            //提前刷新页面
//            // layoutIfNeeded是根据 自动布局 来修改frame
//            self.layoutIfNeeded()
//        }
    }
    
    @IBAction func cancelButtonDidClick(sender: AnyObject) {
        //取消键盘的第一响应者
        textView.resignFirstResponder()
        rightCons.constant = 0
        UIView.animate(withDuration: 0.25) { () -> Void in

            self.layoutIfNeeded()
        }
    }
    

}
