//
//  HMStatusCell.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit

class HMStatusCell: UITableViewCell {

    //工具条的顶部的约束对象
    var toolBarTopCons: Constraint?
    var statusViewModel: HMStatusViewModel? {
        didSet {
//            print(statusViewModel?.status?.pic_urls?.count)
//            print(statusViewModel?.status?.retweeted_status?.pic_urls?.count)
            originalView.statusViewModel = statusViewModel
            statusToolBar.statusViewModel = statusViewModel
    
            //判断是否是转发微博 修改底部toolbar顶部的约束
            //放置cell复用  snp_updateConstraints: 如果约束存在就更新,约束不存在就创建
            
            //在更新约束之前先 卸载toolbar顶部的约束  先记录顶部约束
            self.toolBarTopCons?.deactivate()
            if statusViewModel?.status?.retweeted_status != nil {
                //转发微博
                //修改约束
                statusToolBar.snp.updateConstraints({ (make) -> Void in
                    self.toolBarTopCons = make.top.equalTo(retweetedView.snp.bottom).constraint
                })
                //显示转发微博
                retweetedView.isHidden = false
                //设置数据源
                retweetedView.statusViewModel = statusViewModel
            } else {
                //原创微博
                //修改约束
                statusToolBar.snp.updateConstraints({ (make) -> Void in
                   self.toolBarTopCons = make.top.equalTo(originalView.snp.bottom).constraint
                })
                //隐藏转发微博
                retweetedView.isHidden = true
                //设置数据源
                retweetedView.statusViewModel = nil
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        //设置cell选中的背景色
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置界面
    private func setupUI() {
//        backgroundColor = randomColor()
        //添加子视图
        contentView.addSubview(originalView)
        contentView.addSubview(retweetedView)
        contentView.addSubview(statusToolBar)
        //设置约束
        originalView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(contentView)
            //先设置测试高度
//            make.height.equalTo(100)
        }
        
        //添加约束 线让可能存在的视图在这个占位 等获取了数据之后再动态调整
        retweetedView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(originalView.snp.bottom)
            make.left.right.equalTo(contentView)
//            make.height.equalTo(80)
        }
        statusToolBar.snp.makeConstraints { (make) -> Void in
            //constraint 添加约束 并且记录约束对象
            self.toolBarTopCons = make.top.equalTo(retweetedView.snp.bottom).constraint
            make.left.right.equalTo(contentView)
            make.height.equalTo(36)
        }
        
        //添加contentView的底部约束
        // snp_makeConstraints  - make 屏蔽了frame布局
        contentView.snp.makeConstraints { (make) -> Void in
            //其他的几个约束也需要同时添加 不然contentView只知道底部在哪个地方
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(statusToolBar.snp.bottom)
        }
        
    }
    
    //懒加载子视图控件
    private lazy var originalView: HMStatusOriginalView = HMStatusOriginalView()
    private lazy var retweetedView: HMStatusRetweetedView = HMStatusRetweetedView()
    private lazy var statusToolBar: HMStatusToolBar = HMStatusToolBar()
}
