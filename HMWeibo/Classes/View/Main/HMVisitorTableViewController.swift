//
//  HMVisitorTableViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/8.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

//多继承
// OC中有多继承吗? 如果没有用什么替代 -> 协议
//swift 必选的协议方法如果不实现 就报错
class HMVisitorTableViewController: UITableViewController,HMVisitorLoginViewDelegate {

    
    //定义用户是否登录的标记
    var userLogin = HMUserAccountViewModel.sharedAccountViewModel.userLogin
    
    var visitorView: HMVisitorLoginView?
    //根据用户是否登录 来选择显示 tableView 还是引导用户登录的界面
    //1. loadView 是苹果专门为手写代码准备的, 一旦实现了loadView并且没有实现super xib/sb就会自动失效
    //2. 在loadView如果根视图为nil 会自动调用loadView去实例化根视图
    //3.如果要自定义根视图 可以在loadView方法中去执行
    override func loadView() {
        
        //三目
        userLogin ? super.loadView() : prepareForVisitorLoginView()
    }
    
    private func prepareForVisitorLoginView() {
        //自定义的引导登录的视图
        visitorView = HMVisitorLoginView()
        // addTarget是比较简单的实现方式
        //        v.backgroundColor = UIColor.redColor()
        //设置代理
        visitorView?.visitorDelegate = self
        view = visitorView
        
        //设置导航条
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(HMVisitorLoginViewDelegate.userWillLogin))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(HMVisitorLoginViewDelegate.userWillRegister))
    }
    
    
    //MARK: 实现访客视图协议方法
    func userWillLogin() {
        print("VC中的登录")
        let oauth = HMOAuthViewController()
        let nav = UINavigationController(rootViewController: oauth)
        present(nav, animated: true, completion: nil)
    }
    
    func userWillRegister() {
        print("VC中的注册")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
