//
//  HMComposeViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class HMComposeViewController: UIViewController {
    
    //MARK 按钮的监听事件
    @objc private func selectPicture() {
        print("选择图片")
        //更新约束
        pictureSelector.view.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(ScreenHeight / 3 * 2)
        }
    }
    
    @objc private func selectEmoticon() {
        print("选择表情")
        //textView 如果为 nil 就会显示系统键盘
        print(textView.inputView ?? "")
        textView.inputView = (keyboardView.inputView == nil ? keyboardView : nil)
        textView.reloadInputViews()
        
        //如果不是第一响应者 就成为第一响应者
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }
    
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func send() {
        print("发送")
        guard let token = HMUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token else {
            SVProgressHUD.showError(withStatus: "你暂未登录")
            return
        }

        HMNetworkTools.sharedTools.sendStatus(token: token, status: textView.showFullText(),imageList: pictureSelector.imageList) { (result, error) -> () in
            if error != nil {
                SVProgressHUD.showError(withStatus: "发布微博失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布微博成功")
            self.close()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景颜色
        view.backgroundColor = UIColor.white
        setupUI()
        //注册键盘弹出和收起的通知
        registerNotification()
    }
    
    @objc private func keyboardWillChange(n: NSNotification) {
        print(n)
        let userInfo = n.userInfo!
        //CGRect  是结构体  字典中不能够直接装结构体  -> 应该包装成 NSValue类型的对象
        let rect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //自动布局的页面动画效果
        //1. 修改约束 
        let offsetY = -ScreenHeight + rect.origin.y
        toolBar.snp.updateConstraints { (make) -> Void in
            make.bottom.equalTo(offsetY)
        }
        UIView.animate(withDuration: 0.25) { () -> Void in
             //2. 在动画闭包中 执行父视图的layoutIfNeeded
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func insertEmoticonText(n: NSNotification) {
        print(n)
        //处理用户点击事件
        guard let em = n.object as? HMEmoticon else {
            print("噢 出大事啦")
            return
        }
        textView.insertEmotioncText(em: em)
    }
    
    //MARK: 注册通知
    private func registerNotification() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChange(n:)) , name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(insertEmoticonText(n:)), name: NSNotification.Name(HMEmoticonBtnDidClick), object: nil)
    }
    //MARK: 设置UI界面
    private func setupUI() {
        setNavBar()
        setTextView()
        setToolBar()
        setPictureSelector()
        
        //将toolbar 移到最顶层
        view.bringSubview(toFront: toolBar)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    private lazy var rightBarbuttonItem: UIBarButtonItem = {
        let btn = UIButton()
        //设置文案
        btn.setTitle("发送", for: .normal)
        //添加点击事件
        btn.addTarget(self, action: #selector(send), for: .touchUpInside)
        //设置根据内容显示
        //设置文字颜色
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .selected)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        let barButtonItem = UIBarButtonItem(customView: btn)
        
        return barButtonItem
    }()
    
    private lazy var textView: HMEmoticonTextView = {
        let tv = HMEmoticonTextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        tv.backgroundColor = UIColor(white: 0.95,alpha: 1)
        tv.alwaysBounceVertical = true
//        tv.delegate = self
        tv.keyboardDismissMode = .onDrag
        //设置代理
        tv.delegate = self
        return tv
    }()
    
    //占位文本
    private lazy var placeHolderlabel: UILabel = UILabel(text: "听说下雨天音乐和辣条更配哦", textColor: UIColor.lightGray, fontSize: 18)
    
    private lazy var toolBar: UIToolbar = UIToolbar()
    
    private lazy var pictureSelector: HMPictureSelectorController = HMPictureSelectorController()
    //自定键盘视图
    private lazy var keyboardView: HMEmoticonKeyboardView = HMEmoticonKeyboardView()
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: 设置UI界面
extension HMComposeViewController {
    
    
    private func setPictureSelector() {
        //1.添加子视图控制器
        //以后如果要是使用控制器的视图之前一定要提前持有该控制器  需要添加子视图控制器 --> addChildViewController
        self.addChildViewController(pictureSelector)
        //2.根视图 添加视图控制器的视图
        //
        view.addSubview(pictureSelector.view)
        
        //设置约束
        pictureSelector.view.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.view)
            //设置初始高度
            make.height.equalTo(0)
        }
    }
    
    private func setToolBar() {
        //添加子视图
        view.addSubview(toolBar)
        //设置约束
        toolBar.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.view)
            //工具条默认的高度 44
        }
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture","actionName": "selectPicture"],
            ["imageName": "compose_mentionbutton_background","actionName": "selectPicture"],
            ["imageName": "compose_trendbutton_background","actionName": "selectPicture"],
            ["imageName": "compose_emoticonbutton_background", "actionName": "selectEmoticon"],
            ["imageName": "compose_add_background","actionName": "selectPicture"]]
        
        //添加 UIBarButtonItem到数组中
        for item in itemSettings {
            
            if let actionName = item["actionName"] {
                let barButtonItem = UIBarButtonItem(imageName: item["imageName"], target: self, action: Selector(actionName))
                items.append(barButtonItem)
            }
            
            //添加弹簧
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            items.append(space)
            
        }
        //移除最后一个
        items.removeLast()
        toolBar.items = items
    }
    
    private func setTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(ScreenHeight / 3)
        }
        
        //添加占位文本
        textView.addSubview(placeHolderlabel)
        
        placeHolderlabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp.top).offset(8)
            make.left.equalTo(textView.snp.left).offset(5)
        }
    }
    
    private func setNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style:.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarbuttonItem
        ///  设置右边按钮不可交互
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //设置导航条自定义视图
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 40))
        let titleLabel = UILabel(text: "发布微博", textColor: UIColor.darkGray, fontSize: 16)
        let nameLabel = UILabel(text: HMUserAccountViewModel.sharedAccountViewModel.userAccount?.name ?? "", textColor: UIColor.lightGray, fontSize: 13)
        myView.addSubview(titleLabel)
        myView.addSubview(nameLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(myView.snp.centerX)
            make.top.equalTo(myView.snp.top)
        }
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(myView.snp.centerX)
            make.bottom.equalTo(myView.snp.bottom)
        }
        navigationItem.titleView = myView
    }
}


extension HMComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //隐藏占位文本 
        placeHolderlabel.isHidden = textView.hasText
        //打开发送交互
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}

//extension HMComposeViewController {
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        textView.resignFirstResponder()
//    }
//}
