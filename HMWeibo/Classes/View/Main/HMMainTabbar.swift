//
//  HMMainTabbar.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
//0.333333  1 / UIScreen.mainScreen().scale
class HMMainTabbar: UITabBar {
    
    //重写父类的方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子视图
        addSubview(plusBtn)
    }

    //当该视图通过 xib/sb加载的时候 这个才会执行这个方法 在这个方法内部默认实现报错
    //一旦程序员实现了 init 当前这个类的对象可以通过手写代码创建 默认为不支持通过xib/sb加载
    required init?(coder aDecoder: NSCoder) {
        //默认实现报错
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//        addSubview(plusBtn)
    }
    
    // 获取subViews中 tabbarButton frame  达到把中间的位置空出来
    override func layoutSubviews() {
        super.layoutSubviews()
        //遍历子视图
        let itemW = self.frame.width / 5
        let itemH = self.bounds.height
        //按钮的大小
        let rect = CGRect(x: 0, y: 0, width: itemW, height: itemH)
        var index: CGFloat = 0
        for subView in subviews {
            //UITabBarButton 是私有类
//            print(subView)
            
            if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
                subView.frame = rect.offsetBy(dx: index * itemW, dy: 0)
//                if index == 1 {
//                    index++
//                }
//                index++
                
                index += (index == 1) ? 2 : 1
            }
            
        }
        
        //设置加好按钮的frame 
        plusBtn.frame = rect.offsetBy(dx: 2 * itemW, dy: 0)
//        plusBtn.frame = CGRectOffset(rect, 2 * itemW, -20)
//        //移动到最顶层
//        bringSubviewToFront(plusBtn)
    }
    
    //懒加载加号按钮
    lazy var plusBtn: UIButton = {
        // alloc / init 实例化得到的按钮就是一个自定义的按钮
        let btn = UIButton()
        
        //设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: .highlighted)
        //设置图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        return btn
    }()

}
