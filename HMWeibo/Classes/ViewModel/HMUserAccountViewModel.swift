//
//  HMUserAccountViewModel.swift
//  HMWeibo
//
//  Created by heima on 16/4/9.
//  Copyright © 2016年 heima. All rights reserved.
//


private let userInfoKey = "com.itheima.userifonKey"

import UIKit

//非常多的界面都会找viewmodel获取数据
//viewModel 处理业务逻辑 ,网络请求,数据缓存
class HMUserAccountViewModel: NSObject {
    
    //单例对象
    static let sharedAccountViewModel: HMUserAccountViewModel = HMUserAccountViewModel()
    
    var userAccount: HMUserAccount?
    
    //添加一个计算性属性(只读属性)
    var userLogin: Bool {
        //1.UserAccount的token 如果不为空 && 用户token不过期 用户已经登录
        //  没有过期  -> 过期日期(2016.4.22) 和 当前日期(2016.4.11)比较  -> 过期日期大于 当前日期
        if let u = userAccount, u.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            
            return true
        }
        //将userAccount 设置为 nil
        userAccount = nil
        return false
    }
    
    //增加一个用户头像NSURL类型的属性
    var headImageURL: URL? {
        let url = URL(string: userAccount?.avatar_large ?? "")
        return url
    }
    
    //私有化构造函数
    private override init() {
        super.init()
        userAccount = self.loadUserInfo()
    }

}

//MARK: 用户登录相关的网络请求
extension HMUserAccountViewModel {
    //MARK: 使用授权码 请求accesstoken
    func loadAccessToken(code: String,finished: @escaping (_ isSuccess: Bool) -> () ) {
        
        HMNetworkTools.sharedTools.loadAccessToken(code: code) { (result, error) -> () in
            if error != nil {
                print(error)
                //TODO: 一会儿完善
                finished(false)
                return
            }
            //程序走到这里 就一定成功
            print("授权成功")
            //获取用户信息 在请求成功的回调中 再去获取用户信息
            self.loadUserInfo(tokenResult: result! as AnyObject, finished: finished)
        }
    }
    
    //token, uid
    private func loadUserInfo(tokenResult: AnyObject,finished: @escaping (_ isSuccess: Bool) -> ()) {
        
        //尝试将AnyObject转换为字典
        guard let dict = tokenResult as? [String: AnyObject] else {
            finished(false)
            return
        }
        let token = dict["access_token"]!
        let uid = dict["uid"]!
        
        HMNetworkTools.sharedTools.loadUserInfo(token: token, uid: uid) { (result, error) -> () in
            if error != nil {
                print(error)
                finished(false)
                return
            }
            
            print("获取用户信息成功")
            //将用户信息保存起来
            print(result)
            //将AnyObject 转换为字典类型
            guard var userInfoDict = result as? [String : AnyObject] else {
                finished(false)
                return
            }
            
            //合并字典
            for (k,v) in dict {
                userInfoDict[k] = v
            }
            print(userInfoDict)
            
            self.saveUserAccount(userInfoDict: userInfoDict)
            //执行成功的回调
            finished(true)
        }
    }
}


// 存储数据 , 获取数据
extension HMUserAccountViewModel {
    
    func saveUserAccount(userInfoDict: [String : AnyObject]) {
        
        //保存完整的字典信息  偏好设置中不能保存nil
        let userDefaults = UserDefaults.standard
        
        //1.将字典信息转换为模型对象
        let account = HMUserAccount(dict: userInfoDict)
        
        //给单例对象的用户账户模型属性赋值,为了解决从未登录状态到登录状态用户账户模型为空的问题
        self.userAccount = account
        //2.获取模型对象字典信息
        let keys = ["access_token","avatar_large","name","expires_in","uid","expires_date"]
        let accountDict = account.dictionaryWithValues(forKeys: keys)
        //3.将对象的字典信息保存到偏好设置中
        userDefaults.set(accountDict, forKey: userInfoKey)
        //4.同步
        userDefaults.synchronize()
        
        print(NSHomeDirectory())
    }
    
    //获取沙盒中存储的数据
    func loadUserInfo() -> HMUserAccount? {
        //1.获取字典信息
        guard let dict = UserDefaults.standard.object(forKey: userInfoKey) as? [String : AnyObject] else {
            return nil
        }
        //2.将字典转换为模型  命中缓存
        let account = HMUserAccount(dict: dict)
        return account
    }
}
