//
//  HMStatusPicture.swift
//  HMWeibo
//
//  Created by heima on 16/4/12.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

/*
    SDWebImage 是一个可以加载gif图片框架  而且效率极高
    一旦加载gif图片的时候 内存开销就会特别大
*/

class HMStatusPicture: NSObject {

    var thumbnail_pic: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
//    override func setValue(value: AnyObject?, forKey key: String) {
//        let largeStr = (value as! String).stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
//        super.setValue(largeStr, forKey: key)
//    }
    
    //过滤
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    //MARK: 将对象转化为字符串
    override var description: String {
        let keys = [""]
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict.description
    }
}
