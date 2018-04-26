//
//  ViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/6.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let webView = UIWebView()
    
    var urlString = ""
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载页面
        loadPage()
    }
    
    private func loadPage() {
        if let url = URL(string: urlString)  {
            let request = URLRequest(url: url)
             webView.loadRequest(request)
        }
    }




}

