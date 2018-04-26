//
//  HMStatusToolBar.swift
//  HMWeibo
//
//  Created by heima on 16/4/12.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMStatusToolBar: UIView {
    
    //声明三个按钮  确保按钮一定会有值  不需要管我在哪个地方赋值
    var repostBtn: UIButton!
    var commentBtn: UIButton!
    var ohYeahBtn: UIButton!
    
    
    
    var statusViewModel: HMStatusViewModel? {
        didSet {
            repostBtn.setTitle(statusViewModel?.repostTitle, for: .normal)
            commentBtn.setTitle(statusViewModel?.commentTitle, for: .normal)
            ohYeahBtn.setTitle(statusViewModel?.ohYeahTitle, for: .normal)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置UI界面
    private func setupUI() {
        repostBtn = addChildButton(title: "转发", imageName: "timeline_icon_retweet")
        commentBtn = addChildButton(title: "评论", imageName: "timeline_icon_comment")
        ohYeahBtn = addChildButton(title: "赞", imageName: "timeline_icon_like")
        
        //添加约束, 按钮三等分父视图
        //1.视图平铺
        //2.添加右边的约束
        repostBtn.snp.makeConstraints({ (make) -> Void in
            make.top.left.bottom.equalTo(self)
        })
        commentBtn.snp.makeConstraints({ (make) -> Void in
            make.top.bottom.equalTo(self)
            make.left.equalTo(repostBtn.snp.right)
            make.width.equalTo(repostBtn.snp.width)
        })
        
        ohYeahBtn.snp.makeConstraints({ (make) -> Void in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(commentBtn.snp.right)
            make.width.equalTo(commentBtn.snp.width)
        })
        
        let sep1 = sepView()
        let sep2 = sepView()
        //处理分割线 就是 1个点 / scale
        let w = 1 / UIScreen.main.scale
        //黄金分割比 1:0.618
        let multiplied = 0.4
        //设置约束
        sep1.snp.makeConstraints { (make) -> Void in
//            make.top.bottom.equalTo(self)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(multiplied)
            make.left.equalTo(repostBtn.snp.right)
            make.width.equalTo(w)
        }
        sep2.snp.makeConstraints { (make) -> Void in
//            make.top.bottom.equalTo(self)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(multiplied)
            make.left.equalTo(commentBtn.snp.right)
            make.width.equalTo(w)
        }
    }
    
    private func sepView() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.purple
        addSubview(line)
        
        return line
    }
    
    //传入参数 得到 按钮
    private func addChildButton(title: String, imageName: String) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setImage(UIImage(named: imageName), for: .normal)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), for: .highlighted)
        
        //自适应大小
        btn.sizeToFit()
        addSubview(btn)
        return btn
    }
}
