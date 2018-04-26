//
//  NSDate+Extension.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import Foundation


extension Date {
    //将字符串转化 '日期' 对象
    static func sinaDate(dateString: String) -> Date? {
        sharedDF.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        //指定区域 不指定 在模拟器上 可以正常运行  但是 在真机会崩溃
        sharedDF.locale = Locale(identifier: "en")
        //将对应的字符串转换为 NSDate
        let sinaDate = sharedDF.date(from: dateString)
        
        return sinaDate
    }
    
    
    
    
    /*
    刚刚(一分钟内)
    X分钟前(一小时内)
    X小时前(当天)
    ---------------------------------------------
    昨天 HH:mm(昨天)
    MM-dd HH:mm(一年内)
    yyyy-MM-dd HH:mm(更早期)
    NSCelander  日历对象  提供了非常丰富的日期处理函数
    */
    
    
    func fullDescription() -> String{
        
        //1.获取需要比较的时间和当前时间的间隔
        let cl = NSCalendar.current
        if cl.isDateInToday(self) {
            //当天
            let delta = Int(Date().timeIntervalSince(self))
            if delta < 60 {
                return "刚刚"
            } else if delta < 60 * 60 {
                //在一个小时内
                return ("\(delta / 60)分钟前")
            } else {
                return ("\(delta / 3600)小时前")
            }
        } else {
            
            //实例化 日期格式化对象
            let comman = "HH:mm"
            if cl.isDateInYesterday(self) {
                //昨天
                sharedDF.dateFormat = "昨天 " + comman
            } else {
                //非昨天
                //把系统当前日期和传过来的日期对象比较 两个日起对象之间相隔多少年
                
                let coms1 = cl.component(.year, from: self)
                let coms2 = cl.component(.year, from: Date())
                
                if coms1 == coms2{
                    //当年
                    sharedDF.dateFormat = "MM-dd " + comman
                } else {
                    //非当年
                    sharedDF.dateFormat = "yyyy-MM-dd " + comman
                }
            }
            let str = sharedDF.string(from: self)
            return str
        }
    }
}
