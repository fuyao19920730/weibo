//
//  HMStatus.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//  一条微博记录的模型

import UIKit

class HMStatus: NSObject {
    
    /// 唯一的一条微博记录
    //在64位的设设备上 没有任何问题,整型数据的长度为 64位
    //在32的设置的上 整性数据的长度就被截断
    var id: Int64 = 0
    /// 微博创建时间
    var created_at: String?
    /// 微博正文
    var text: String?
    /// 微博来源
    var source: String?
    /// 转发的数量
    var reposts_count: Int = 0
    /// 评论的数量
    var comments_count: Int = 0
    /// 赞的数量
    var attitudes_count: Int = 0
    //用户属性
    var user: HMUser?
    
    //转发微博
    var retweeted_status: HMStatus?
    
    //声明图片的数组属性
    var pic_urls: [HMStatusPicture]?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
     func setValue(value: AnyObject?, forKey key: String) {
        //需要判断key 是否是 user
        if key == "user" {
            //字典转模型
            user = HMUser(dict: value as! [String : AnyObject])
            //return 一定不能忘记, 字典转模型就白做了
            return
        }
        
        //需要判断key 是否是 user
        if key == "retweeted_status" {
            //字典转模型
            retweeted_status = HMStatus(dict: value as! [String : AnyObject])
            return
        }
        
        if key == "pic_urls" {
            //遍历数组 获取字典转换为模型 添加到模型数组中
            let array = value as! [[String : String]]
            var tempArray = [HMStatusPicture]()
            for item in array {
                //字典转模型
                let pic = HMStatusPicture(dict: item)
                tempArray.append(pic)
            }
            //给属性赋值
            pic_urls = tempArray
            return
        }
        //一定要super
        super.setValue(value, forKey: key)
        
    }
    
    //过滤
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
