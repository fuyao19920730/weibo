//
//  HMWelcomeViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/9.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
//import AFNetworking

class HMWelcomeViewController: UIViewController {
    
    
    override func loadView() {
         view = UIImageView(image: UIImage(named: "ad_background"))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //在viewDidLoad阶段获取的根视图的大小可能不是准确
        setupUI()
        print(view.frame)
        
    }
    
    override func viewWillLayoutSubviews() {
        //会自动给根视图大小重新设置和设备的屏幕尺寸大小一致的size
        super.viewWillLayoutSubviews()
        print(view.frame)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(view.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(view.frame)
        //执行动画效果
        startAnimation()
    }

    
    //设置界面
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(nameLabel)
        
        //将用户头像处理成圆角
        iconView.cornerRadius = 45
        iconView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-180)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
        
        //加载头像
        //网络提供的数据不能够直接使用 需要转换数据(洗数据)
        iconView.sd_setImage(with: HMUserAccountViewModel.sharedAccountViewModel.headImageURL)
    }
    
    
    private func startAnimation() {
        let offset = -ScreenHeight + 180
        nameLabel.alpha = 0
        //执行动画  弹簧动画
        /*
        1.usingSpringWithDamping : 阻尼系数 弹簧系数 0 ~ 1,阻尼系数越小弹簧效果越大 
        2. initialSpringVelocity: 加速度  开始的时候的加速度, 值越大 开始的速速就越快
        3. 动画的可选项OC: 按位与 XXX | XXX swift: [xxx,xxx]
        */
        //动画效果要修改的代码 frame布局 修改frame
        self.iconView.snp.updateConstraints({ (make) -> Void in
            //更新 头像的地步约束
            make.bottom.equalTo(self.view.snp.bottom).offset(offset)
        })
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [], animations: { () -> Void in
            //强制刷新页面 提前刷新页面
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                //添加文案显示的动画
                UIView.animate(withDuration: 0.6, animations: { () -> Void in
                    //显示nameLabel
                    self.nameLabel.alpha = 1
                    }, completion: { (_) -> Void in
                        print("OK")
                        // 跳转页面
//                        UIApplication.sharedApplication().keyWindow?.rootViewController = HMMainViewController()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMSwitchRootViewController), object: "Main")
                })
        }
    }
    
    
    //懒加载控件
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    private lazy var nameLabel: UILabel = UILabel(text: HMUserAccountViewModel.sharedAccountViewModel.userAccount?.name ?? "", textColor: UIColor.darkGray, fontSize: 16)

    

}
