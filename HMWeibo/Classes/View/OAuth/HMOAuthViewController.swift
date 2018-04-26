//
//  HMOAuthViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/9.
//  Copyright © 2016年 heima. All rights reserved.
// 1. 使用webView加载登录授权的页面

import UIKit
import SVProgressHUD




class HMOAuthViewController: UIViewController {
    
    //自定义根视图为 webView
    let webView = UIWebView()
    override func loadView() {
        view = webView
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航条
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(fullAccount))
        //使用webView加载授权页面
        let urlStirng = "https://api.weibo.com/oauth2/authorize?" + "client_id=" + client_id + "&redirect_uri=" + redirect_uri
        let url = URL.init(string: urlStirng)
        let requset = URLRequest(url: url!)
        webView.loadRequest(requset)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //隐藏HUD
        SVProgressHUD.dismiss()
    }
    
    @objc private func fullAccount() {
        //设置默认的账户和密码
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('userId').value = '18801403328', document.getElementById('passwd').value = 'fuyao1127' ")
    }
    
    //关闭页面
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}

//遵守webView的协议
extension HMOAuthViewController: UIWebViewDelegate {
    //开始加载页面
    func webViewDidStartLoad(_ webView: UIWebView) {
        //开启等待指示器
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //取消用户等待指示器
        let webTitle = webView.stringByEvaluatingJavaScript(from: "document.title")
        title = webTitle
        SVProgressHUD.dismiss()
    }
    
    
    //协议方法返回值为 bool类型 如果返回 true 就可才正常工作,否则就不能够工作
    //在授权成功的回调页中获取 授权code
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.url?.absoluteString ?? ""
        //满足字符串中包好了 code=
        let flag = "code="
        if urlString.contains(flag) {
           //授权成功
            let range = urlString.range(of: flag)!
            

            let code = urlString.substring(from: range.upperBound)
            print(code)
            //使用授权码  获取accesstoken
//            loadAccessToken(code)
            HMUserAccountViewModel.sharedAccountViewModel.loadAccessToken(code: code, finished: { (isSuccess) -> () in
                if !isSuccess {
                    //表示登录失败
                    SVProgressHUD.showError(withStatus: AppErrorTip)
                    return
                }
                // 单例对象的account 有值吗?  单例对象的模型没有赋值
                
                //跳转到欢迎页面 (用户名 + 用户头像)
//                SVProgressHUD.showSuccessWithStatus("登录成功")
                //OAuth 是一个被 modal出来的页面  需要手动dismiss 不然会造成页面无法释放
                self.dismiss(animated: false, completion: { () -> Void in
                    //不推荐这种方式切换根视图控制器
//                    UIApplication.sharedApplication().keyWindow?.rootViewController = HMWelcomeViewController()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMSwitchRootViewController), object: nil)
                })
                

            })
            //不加载授权成功的回调页面
            return false
        }
        print(urlString)
        return true
    }
}
