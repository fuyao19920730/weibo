//
//  HMEmoticonToolBar.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

/*
    容器视图 只负责装子视图 不负责渲染视图
*/

class HMEmoticonToolBar: UIStackView {

    var currentSelectedBtn: UIButton?
    
    var btnDidSelected: ((_ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置轴
        axis = .horizontal
        distribution = .fillEqually
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
//        backgroundColor = UIColor.redColor()
        let packages = HMEmoticonManager.sharedEmoticon.packages
        for (index,p) in packages.enumerated() {
            var imgName = "compose_emotion_table_mid"
            if index == 0 {
                    //加载第一个分组
                imgName = "compose_emotion_table_left"
            } else if index == packages.count - 1 {
                //加载最后一个分组
                imgName = "compose_emotion_table_right"
            }
            addChildButtons(title: p.name ?? "", backImageName: imgName,index: index)
        }
        
    }
    
    
    private func addChildButtons(title: String, backImageName: String,index: Int) {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .selected)
        btn.addTarget(self, action: #selector(btnDidClick(btn:)), for: .touchUpInside)
        
        
        btn.addTarget(self, action: Selector(("btnDidClick:")), for: .touchUpInside)
        btn.setBackgroundImage(UIImage.init(named: backImageName + "_normal"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: backImageName + "_selected"), for: .selected)
        
        btn.tag = index + baseTag
        addArrangedSubview(btn)
        
        if index == 0 {
            btn.isSelected = true
            //需要记录当前选中的按钮
            currentSelectedBtn = btn
        }
        
    }
    
    @objc private func btnDidClick(btn: UIButton) {
        print("按钮被点击")
        setBtnSelected(btn: btn)
        
        //可选类型的闭包的只能提示 不好  可以先加上可选项的标识 ?? 再加 . 再去 .
        btnDidSelected?(btn.tag - baseTag)
    }
    
    
    func selectedBtnWithSection(section: Int) {
        //根据section 获取按钮 tag = 0 取到的对象 是自己 不能够占据 tag = 0

        let btn = viewWithTag(section + baseTag) as! UIButton
        
        setBtnSelected(btn: btn)
        
    }
    
    
    func setBtnSelected(btn: UIButton)  {
        
        //如果点击的按钮就是当前选中的按钮
        if btn == currentSelectedBtn {
            return
        }
        //记录
        currentSelectedBtn?.isSelected = false
        currentSelectedBtn = btn
        //设置按钮的选中状态
        btn.isSelected = true
    }

}
