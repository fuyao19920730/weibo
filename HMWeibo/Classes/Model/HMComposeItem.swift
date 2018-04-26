//
//  HMComposeItem.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMComposeItem: NSObject {
    
    var icon: String?
    var title: String?
    var target: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //过滤
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
}
