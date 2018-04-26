//
//  HMVisitorLoginView.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit

//声明协议
@objc protocol HMVisitorLoginViewDelegate: NSObjectProtocol {
    //声明方法 
    //登录的协议方法
    //optional 协议也是默认不添加 @objc 但是要使用 optional  就必须添加
    @objc optional func userWillLogin()
    
    //注册的协议方法
    @objc optional func userWillRegister()
}



class HMVisitorLoginView: UIView {

    
    //声明代理对象  需要考虑循环引用
    //swift 中属性默认的修饰 都是strong
    weak var visitorDelegate: HMVisitorLoginViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //对外提供设置界面的方法 
    //参数的默认值 这个参数可以不传
    func setVisitorInfo(tipText: String, imageName: String, isHome: Bool = false) {
        if isHome {
            //执行动画
            startAnimation()
        } else {
            //隐藏大房子
            largeHouse.isHidden = true
            
            //将圈圈 移动到最顶部
            bringSubview(toFront: circleIcon)
        }
        tipLabel.text = tipText
        circleIcon.image = UIImage(named: imageName)
    }
    
    private func startAnimation() {
        //基本动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //基本设置
        anim.repeatCount = MAXFLOAT
        //设置动画时间
        anim.duration = 15
        //
        anim.toValue = 2 * Double.pi
        // 动画执行结束 或者 当前处于非活跃状态下 动画不移除图层
        anim.isRemovedOnCompletion = false
        //添加到 圈圈的图层上
        circleIcon.layer.add(anim, forKey: nil)
    }
    
    //MARK: 设置UI界面
    private func setupUI() {
        
        
        //VFL
        /**
        *  获取一个约束对象
        *
        *  @param item         需要设置约束的视图
        *  @param attribute    需要约束的属性
        *  @param relatedBy    约束优先级 一般都是 精准约束 .Equal
        *  @param toItem       约束参考的对象
        *  @param attribute    参考的属性
        *  @param multiplier   乘积系数 一般使用 1  不能够使用 0
        *  @param constant     约束值
        *
        *  @return 约束对象
        */
        //将约束对象添加到父控件上
        //手写代码添加约束 默认frame布局还是开启 就应该关闭frame布局
        //  view1.attr1 = view2.attr2 * multiplier + constant
        //        circleIcon.translatesAutoresizingMaskIntoConstraints = false
        //        self.addConstraint( NSLayoutConstraint(item: circleIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        //        self.addConstraint( NSLayoutConstraint(item: circleIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addSubview(circleIcon)
        addSubview(backImageView)
        addSubview(largeHouse)
        addSubview(tipLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        circleIcon.snp.makeConstraints { (make) -> Void in
            //make 就是 circleIcon 取消了frame布局的对象
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-80)
        }
        
        largeHouse.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(circleIcon.snp.center)
        }
        
        tipLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(circleIcon.snp.bottom).offset(16)
            //为了能够自动换行 需要约束宽度
            make.width.equalTo(230)
            //约束高度 解决按钮跳动的问题
            make.height.equalTo(40)
            make.centerX.equalTo(circleIcon.snp.centerX)
        }
        
        loginBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(tipLabel.snp.left)
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            //约束宽度
            make.width.equalTo(100)
        }
        
        registerBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(tipLabel.snp.right)
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            make.width.equalTo(100)
        }
        
        backImageView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(circleIcon)
        }
        
        //设置背景色  使用sRGB 取色  不过在不同的屏幕上显示的颜色是不一样的
        let value: CGFloat = 237 / 255.0
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1)
       
        //添加按钮点击事件
        loginBtn.addTarget(self, action: #selector(loginBtnDidClick), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnDidClick), for: .touchUpInside)
    }
    
    
    //MARK: 按钮的监听事件
    @objc private func loginBtnDidClick() {
        print("登录")
        //使用代理对象 调用协议方法
        //1.判断代理对象是否不为 nil 2. 判断代理对象是否响应协议方法
        visitorDelegate?.userWillLogin?()
    }
    
    @objc private func registerBtnDidClick() {
        print("注册")
        visitorDelegate?.userWillRegister?()
    }
    
    //把子视图 懒加载出来
    //背景视图
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //圈圈  大小和图片的大小一致 没有 origin
    private lazy var circleIcon: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //大房子
    private lazy var largeHouse: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示文案
    private lazy var tipLabel: UILabel = UILabel(text: "关注一些人", textColor: UIColor.darkGray, fontSize: 14)
    
    //登录 注册按钮
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //设置背景图片
        let image = UIImage(named: "common_button_white_disable")!
        let capW = Int(image.size.width * 0.5)
        let capH = Int(image.size.height * 0.5)
        btn.setBackgroundImage(image.stretchableImage(withLeftCapWidth: capW, topCapHeight: capH), for: .normal)
        return btn
    }()
    
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .normal)
        return btn
    }()


}
