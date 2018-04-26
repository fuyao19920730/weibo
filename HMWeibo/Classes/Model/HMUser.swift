//
//  HMUser.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//  微博作者的信息

import UIKit

class HMUser: NSObject {

    /// 用户名称
    var name: String?
    /// 用户头像
    var profile_image_url: String?
    
    /// 微博等级 0 ~6 等级
    var mbrank: Int = 0
    /// 认证类型 -1：没有认证，1：认证用户，2,3,5: 企业认证，220: 达人
    var verified = -1
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //过滤
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //MARK: 将对象转化为字符串
    override var description: String {
        let keys = ["name","profile_image_url"]
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict.description
    }
    
}
