//
//  HMTempViewController.swift
//  HMWeibo
//
//  Created by heima on 16/4/8.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景色
//        view.backgroundColor = UIColor.whiteColor()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_back_withtext", title: "返回", target: self, action: "back")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch",  target: self, action: "push")
    }
    
//    @objc private func back() {
//        navigationController?.popViewControllerAnimated(true)
//    }
//    
    
    @objc private func push() {
        print("pop")
        let temp = HMTempViewController()
        //push到子页面
        navigationController?.pushViewController(temp, animated: true)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
