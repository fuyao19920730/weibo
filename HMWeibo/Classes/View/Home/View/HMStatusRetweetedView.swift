//
//  HMStatusRetweetedView.swift
//  HMWeibo
//
//  Created by heima on 16/4/12.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit

class HMStatusRetweetedView: UIView {
    
    var bottomCons: Constraint?
    
    var statusViewModel: HMStatusViewModel? {
        didSet {
//            contentLabel.text = statusViewModel?.status?.retweeted_status?.text
            contentLabel.attributedText = statusViewModel?.retweetedAttributeString
            //卸载约束
            self.bottomCons?.deactivate()
            if let urls = statusViewModel?.status?.retweeted_status?.pic_urls, urls.count > 0 {
                //有配图视图
                //更新约束
                self.snp.updateConstraints({ (make) -> Void in
                    self.bottomCons = make.bottom.equalTo(pictureView.snp.bottom).offset(StatusCellMargin).constraint
                })
                //设置数据源
                pictureView.imageURLs = urls
                //显示配图视图
                pictureView.isHidden = false
            } else {
                //没有配图视图
                //更新约束
                self.snp.updateConstraints( { (make) -> Void in
                    self.bottomCons = make.bottom.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin).constraint
                })
                //设置数据源 nil
                pictureView.imageURLs = nil
                //隐藏配图视图
                pictureView.isHidden = true
                
            }
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
        //灰度色
        backgroundColor = UIColor(white: 0.9, alpha:1)
        addSubview(contentLabel)
        addSubview(pictureView)
        contentLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.equalTo(self).offset(StatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLabel.snp.left)
        }
        
        
        //转发微博高度自动计算  约束转发微博的底部 
        self.snp.makeConstraints { (make) -> Void in
            self.bottomCons = make.bottom.equalTo(pictureView.snp.bottom).offset(StatusCellMargin).constraint
        }
    }
    
    //懒加载子视图

    private lazy var contentLabel: UILabel = UILabel(text: "我是转发微博哈哈", textColor: UIColor.darkGray, fontSize: WeiboContentLabelFont, margin: StatusCellMargin)
    
    private lazy var pictureView: HMStatusPictureView = HMStatusPictureView()
    
}
