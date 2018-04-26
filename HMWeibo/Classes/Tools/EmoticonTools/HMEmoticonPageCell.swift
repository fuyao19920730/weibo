//
//  HMEmoticonPageCell.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit

/*
21 个视图  
一个cell 对应一个数组
*/

class HMEmoticonPageCell: UICollectionViewCell {
    
    
    var emoticons: [HMEmoticon]? {
        didSet {
            //给按钮绑定模型 //将按钮添加到数组中
            //遍历
            //在赋值之前先隐藏按钮
//            for btn in buttonArray {
//                btn.hidden = true
//            }
            for (index,em) in emoticons!.enumerated() {
                //获取对应的按钮 绑定模型
            
                let btn = buttonArray[index]
                btn.em = em
               
            }
        }
    }
    
    lazy var buttonArray = [HMEmoticonButtton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置UI界面
    private func setupUI() {
        //添加21个坑
        for i in 0..<21 {
            //添加按钮
            let leftMargin: CGFloat = 5
            let bottomMargin: CGFloat = 30
            let w = (UIScreen.main.bounds.width - 2 * leftMargin) / CGFloat(EmoticonColCount)
            let h = (self.bounds.height - bottomMargin) / CGFloat(EmoticonRowCount)
            let btn = HMEmoticonButtton()
            btn.addTarget(self, action: #selector(btnDidClick(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
//            btn.backgroundColor = UIColor(red:CGFloat(random() % 256) / 255, green: CGFloat(random() % 256) / 255, blue: CGFloat(random() % 256) / 255, alpha: 1)
            let row = i / EmoticonColCount
            let col = i % EmoticonColCount
            //设置按钮的frame
            let x: CGFloat = leftMargin + w * CGFloat(col)
            let y: CGFloat = CGFloat(row) * h
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            
            contentView.addSubview(btn)
            //添加到数组中
            buttonArray.append(btn)
        }
        
        //添加手势
        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        //添加到当前视图
        contentView.addGestureRecognizer(ges)
    }
    
    @objc private func longPress(ges: UILongPressGestureRecognizer) {
        //获取手势触摸对应的点
        let point = ges.location(in: contentView)
        //找到对应的按钮  就开始监听手势的状态
        switch ges.state {
        case .began,.changed:
            print("添加popView")
            //需要判断当前获取的点在哪一个button上
            guard let btn = buttonWithPoint(point: point) else {
                return
            }
            popView.show(button: btn)
        default:
            print("移除popView")
//            popView.removeFromSuperview()
            popView.isHidden = true
        }
    }
    
    
    //MARK: 根据手势触摸的点  找到对应的btn
    private func buttonWithPoint(point: CGPoint) -> HMEmoticonButtton? {
        //遍历按钮的数组
        for btn in buttonArray {
            //判断按钮的frame 是否包含了触摸点
            if btn.frame.contains(point) {
                return btn
            }
        }
        return nil
    }
    
    @objc private func btnDidClick(btn: HMEmoticonButtton) {
        
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMEmoticonBtnDidClick), object: btn.em)
        
        popView.show(button: btn)
        
        //稍后移除
        popView.dimissAfter()
    }
    
    //懒加载子视图
    private lazy var testLabel: UILabel = {
        let l = UILabel()
        
        l.textColor = UIColor.red
        l.font = UIFont.systemFont(ofSize: 30)
        
        return l
    }()
    
    private lazy var popView: HMEmoticonPopView = {
        let pop = HMEmoticonPopView.loadPopView()
        pop.isHidden = true
        return pop
    }()
}
