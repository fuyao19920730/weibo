
//
//  HMUserAccount.swift
//  HMWeibo
//
//  Created by heima on 16/4/9.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

//给需要保存的用户信息添加属性  其他的不需要保存的就直接过滤掉
class HMUserAccount: NSObject {
    //用户授权的唯一票据
    @objc var access_token: String?
    //access_token的生命周期，单位是秒数。 token 在多少秒之后(expires_in)会过期
    //10 + 当前时间  => 获取具体的过期的日期
    //当前的日期 和 过期日期比较
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            //立即计算过期日期
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    //添加过期日期的字段 开发者账号的过期日期是 5年, 测试账号的过期日期是 1天
    @objc var expires_date: NSDate?
    //标识唯一用户的id
    @objc var uid: String?
    //用户显示名称
    @objc var name: String?
    //用户头像 180 * 180  -> 大小(Point)  -> 90 * 90
    @objc var avatar_large: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //MARK: 将对象转化为字符串
    override var description: String {
        let keys = ["access_token","avatar_large","name","uid","expires_in","expires_date"]
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict.description
    }
}
