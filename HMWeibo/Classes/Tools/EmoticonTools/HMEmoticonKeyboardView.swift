//
//  HMEmoticonKeyboardView.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit

/*
    系统键盘的高度: 1.在 iPhone 6+ 上面 是 226
                  2.在其他设备上 是 216
*/
private let EmoticonViewHeight: CGFloat = 220
private let EmoticonToolBarHeight: CGFloat = 37
private let EmoticonCellId = "EmoticonCellId"
class HMEmoticonKeyboardView: UIView {
    
    
    var packages = HMEmoticonManager.sharedEmoticon.packages
    
    override init(frame: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: 0, height: EmoticonViewHeight)
        super.init(frame: rect)
//        backgroundColor = UIColor.darkGrayColor()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 设置界面
    private func setupUI() {
        addSubview(toolBar)
        addSubview(collectionView)
        addSubview(pageControl)
        toolBar.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(EmoticonToolBarHeight)
        }
        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        pageControl.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top).offset(-5)
        }
        
        toolBar.btnDidSelected = { (index: Int) -> () in
            print(index)
            //点击toolbar的按钮 让集合视图滚动到对应的组
            let indexPath = IndexPath(item: 0, section: index)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            self.updatePageControl(indexPath: indexPath)
        }
        
        //给pageControl 数据源设置初始值
        //放到异步队列中执行 等待主队列执行完毕之后再执行

        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            self.updatePageControl(indexPath: indexPath)
        }
    }
    
    
    private lazy var toolBar: HMEmoticonToolBar = HMEmoticonToolBar(frame: CGRect.zero)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: EmoticonViewHeight - EmoticonToolBarHeight)
        //设置滚动方向
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.98, alpha: 1)
        //注册cell 和可重用标示符
        cv.register(HMEmoticonPageCell.self, forCellWithReuseIdentifier: EmoticonCellId)
        //设置数据源
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        //去掉弹簧效果
        cv.bounces = false
        
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let p = UIPageControl()
        
        p.numberOfPages = 6
        p.currentPage = 3
        //设置颜色
//        p.currentPageIndicatorTintColor = UIColor.redColor()
//        p.pageIndicatorTintColor = UIColor.yellowColor()
        p.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        p.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        
        return p
    }()
}



//MARK: 数据源方法
extension HMEmoticonKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].sectionEmoticon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCellId, for: indexPath as IndexPath) as! HMEmoticonPageCell
        cell.emoticons = packages[indexPath.section].sectionEmoticon[indexPath.item]
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前集合视图显示的是哪一组
        var center = collectionView.center
        center.x = center.x + collectionView.contentOffset.x
        print(center.x)
        //1.获取当前屏幕中显示的cell的数组  最多显示两个 最少显示一个
        let indexPaths = collectionView.indexPathsForVisibleItems
        //遍历indexPath, 获取indexPath对应的cell
        for indexPath in indexPaths {
            //获取对应的cell
            let cell = collectionView.cellForItem(at: indexPath)
            //判断哪一个cell的frame 包含了 目标中心点  如果包含了就更新pageControl
            if cell!.frame.contains(center) {
                //更新数据
                updatePageControl(indexPath: indexPath)
            }
        }
    }
    
    func updatePageControl(indexPath: IndexPath) {
        //当前显示的组中有多少个分组表情数组  -> (cell)
        pageControl.numberOfPages = HMEmoticonManager.sharedEmoticon.packages[indexPath.section].sectionEmoticon.count
        pageControl.currentPage = indexPath.item
    }
}
