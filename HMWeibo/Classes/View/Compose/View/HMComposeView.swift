  //
//  HMComposeView.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit


class HMComposeView: UIView {
    
    var target: UIViewController?
    
    //外界调用的方法 将当前视图对象添加到视图上 设置 target值 
    func show(target: UIViewController) {
        self.target = target
        //使用target的view添加对象自己
        target.view.addSubview(self)
    }
    
    
    override init(frame: CGRect) {
        let rect = UIScreen.main.bounds
        super.init(frame: rect)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        //执行动画  依次获取每个按钮 给按钮执行动画
        for (index,button) in buttonArray.reversed().enumerated() {
            animationWith(button: button, index: index)
        }
    }

    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //执行动画  依次获取每个按钮 给按钮执行动画
        for (index,button) in buttonArray.enumerated() {
            animationWith(button: button, index: index, isUp: true)
        }
    }
    
    private func animationWith(button: HMComposeButton, index: Int, isUp: Bool = false) {
        UIView.animate(withDuration: 0.8, delay: Double(index) * 0.03, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: [], animations: { () -> Void in
            //修改按钮的中心点
            button.center = CGPoint(x: button.center.x, y: button.center.y + (isUp ? -350 : 350))
            }, completion: { (_) -> Void in
                if !isUp {
                    //向下的效果
                    self.removeFromSuperview()
                }
        })
    }
    
    
    //MARK: 设置UI界面
    private func setupUI() {
        backgroundColor = randomColors
        addSubview(backImageView)
        addSubview(sloganView)
        //设置约束
        backImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.snp.edges)
        }
        
        sloganView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(100)
        }
        
        
        //添加按钮
        addChildButtons()
    }
    
    
    @objc private func buttonDidClick(button: HMComposeButton) {
        //执行动画效果   1.被点击的按钮 执行放大的动画  其他按钮执行缩小的动画
        for btn in buttonArray {
            var scale: CGFloat = 0
            if button == btn {
                //就是被点击的按钮
                scale = 2.0
            } else {
                scale = 0.1
            }
            //执行动画东效果
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                //设置alpha
                btn.alpha = 0
                btn.transform  = CGAffineTransform(scaleX: scale, y: scale)
                }, completion: { (_) -> Void in
                    print("OK")
            })
        }
        
        //执行页面跳转
        //获取按钮对应的模型
        guard let className = button.composeItem?.target else {
            print("className 为空")
            return
        }
        //需要记忆
        //根据字符串获取对应的类型
        let classType = NSClassFromString(className) as! UIViewController.Type
        let vc = classType.init()
        let nav = UINavigationController(rootViewController: vc)
        target?.present(nav, animated: true, completion: { () -> Void in
            self.removeFromSuperview()
        })
        
        
    }
    
    //添加6个按钮
    private func addChildButtons() {
        let count = composeInfos.count
        let bW: CGFloat = 80
        let bH: CGFloat = 110
        let margin: CGFloat = (ScreenWidth - 3 * bW) / 4
        let rect = CGRect(x: 0, y: 0, width: bW, height: bH)
        for i in 0..<count {
            
            let item = composeInfos[i]
            let button = HMComposeButton()
            
            button.addTarget(self, action: #selector(buttonDidClick(button:)), for: .touchUpInside)
            button.composeItem = item
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.titleLabel?.textAlignment = .center
            addSubview(button)
            
            //修改按钮的frame
            //获取行 和 列
            let row = i / 3
            let col = i % 3
            
            
            let offsetX = (bW + margin) * CGFloat(col) + margin
            let offsetY = (bH + margin) * CGFloat(row) + ScreenHeight
            button.frame = rect.offsetBy(dx: offsetX, dy: offsetY)
            
            //添加到数组中
            buttonArray.append(button)
        }
    }
    
    //懒加载子视图
    
    //磨砂效果的背景视图
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage.snapshotScreen().applyLightEffect())
    
    private lazy var sloganView: UIImageView = UIImageView(image: UIImage(named: "compose_slogan"))
    
    
    //声明保存按钮的数组
    private lazy var buttonArray: [HMComposeButton] = [HMComposeButton]()
    private lazy var composeInfos: [HMComposeItem] = {
        //从文件中读取数组
        let path = Bundle.main.path(forResource: "Compose.plist", ofType: nil)!
        let array = NSArray(contentsOfFile: path) as! [[String : String]]
        //遍历数组  字典转模型
        var itemArray = [HMComposeItem]()
        for item in array {
            let composeItem = HMComposeItem(dict: item as [String : AnyObject])
            itemArray.append(composeItem)
        }
        
        return itemArray
    }()
}
