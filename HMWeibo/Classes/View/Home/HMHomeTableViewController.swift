//
//  HMHomeTableViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SVProgressHUD

private let HomeCellID = "HomeCellID"

class HMHomeTableViewController: HMVisitorTableViewController {
    
    //tableView对应的视图模型
    private lazy var statusListViewModel: HMStatusListViewModel = HMStatusListViewModel()
    //自定义下拉刷新控件
    let myRefresh = HMRefreshControl()
    //模型数组
    //视图层次结构已经准备完毕
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置界面
        setupUI()
        //加载数据
        loadData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if userLogin {
//            loadData()
//        }
        
    }
    
    private func setupUI() {
        //设置访客视图信息
        if !userLogin {
            //用户没有登录进入这个分支
            visitorView?.setVisitorInfo(tipText: "关注一些人,回到这里看看有什么惊喜", imageName: "visitordiscover_feed_image_smallicon", isHome: true)
            return
        }
        
        //设置导航条上的自定义按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",target: self, action: #selector(push))
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch",target: self, action: #selector(push))
        
        prepareForTableView()
    }
    
    private func prepareForTableView() {
        //注册cell
        tableView.register(HMStatusCell.self, forCellReuseIdentifier: HomeCellID)
        //设置tableViewCell的固定高度为 
        //1.设置行高为自动计算
        tableView.rowHeight = UITableViewAutomaticDimension
        //2.设置预估行高  ==> 通过预估行高 给tableView计算 预估的contentSize  -> tableView才可以滚动  -> 减少 tableView行高的计算
        tableView.estimatedRowHeight = 300
        //设置分割线
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = indicatorView
        
        myRefresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.addSubview(myRefresh)
    }
    
    @objc private func push() {
        //进入子页面
        print("push")
        let temp = HMTempViewController()
//        temp.hidesBottomBarWhenPushed = true
        //push到子页面
        navigationController?.pushViewController(temp, animated: true)
    }
    
    
    @objc private func loadData() {
        //使用ViewModel请求数据
        statusListViewModel.loadHomagePageData(isPullup: indicatorView.isAnimating) { (isSuccess) -> () in
            //不管成功还是失败都是应该停止refreshControl的转动 并且回到最顶部
//            self.refreshControl?.endRefreshing()
            self.myRefresh.endRefreshing()
            if !isSuccess {
                SVProgressHUD.showError(withStatus: AppErrorTip)
                return
            }
            
            
            //停止菊花的转动
            self.indicatorView.stopAnimating()
            //刷新视图
            self.tableView.reloadData()
        }
    }
    
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        v.startAnimating()
        return v
    }()

}

//MARK: 实现数据源 & 协议方法
extension HMHomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
         'unable to dequeue a cell with identifier HomeCellId - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
         必须手动注册cell  xib/sb -> 属性设置框中填写 可重用标示符
         手写代码  手动调用注册cell的方法
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellID, for: indexPath) as! HMStatusCell
        cell.statusViewModel = statusListViewModel.statusArray[indexPath.row]
        
        
        //添加一个标记 如果正在上拉操作就不执行以下分支
        //正在加载最后一个cell 并且 小菊花没有转动
        if  !indicatorView.isAnimating && indexPath.row == statusListViewModel.statusArray.count - 1 {
            //表示正在加载最后一个cell
            //只是loadData
            //转动小菊花
            indicatorView.startAnimating()
            loadData()
            
        }
        return cell
    }
}


