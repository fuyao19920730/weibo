//
//  HMStatusDAL.swift
//  HMWeibo
//
//  Created by heima on 16/4/25.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
/*
 加载微博数据   -> [[String : AnyObject]]
 存储数据
 */

class HMStatusDAL: NSObject {

    //加载微博首页数据
    class func loadHomeStatus(token: String, since_Id: Int64, max_id: Int64, finished: @escaping (_ result: [[String : AnyObject]]?) -> () ) {
        //1.判断本地是否有缓存数据
        if let result = checkOutStatus(since_Id: since_Id, max_id: max_id), result.count > 0 {
            //2.如果本地有缓存数据  就直接显示本地的缓存数据 --> 节省用户流量
            //TODO 返回本地数据
            finished(result)
            return
        }
        
        //3.如果没有缓存数据, 就应该发送网络请求请求网络数据  返回网络数据
        HMNetworkTools.sharedTools.loadHomePageData(token: token,max_id: max_id,since_id: since_Id) { (result, error) -> () in
            if error != nil {
                finished(nil)
                return
            }
            //网络请求成功
            //            print(result)
            //1.将result 转换为字典类型
            guard let dict = result as? [String : AnyObject] else {
                finished(nil)
                return
            }
            //2.根据 statuses key 获取对应的字典类型的数组
            guard let array = dict["statuses"] as? [[String : AnyObject]] else {
                finished(nil)
                return
            }
            finished(array)
            
            //4.网络数据请求成功之后  应该保存数据到本地  -> 数据库 -> status.db
            saveStatus(array: array)

        }
    }
    
    //查询数据
    class func checkOutStatus(since_Id: Int64, max_id: Int64) ->[[String : AnyObject]]?{
        guard let userId = HMUserAccountViewModel.sharedAccountViewModel.userAccount?.uid else {
            print("用户暂未登录")
            return nil
        }
        //sql 分页查找数据库中的数据
        var sql = "SELECT status FROM T_Status WHERE userId = \(userId) "
        
        if since_Id > 0 {
            //下拉刷新数据
           sql += "AND statusId > \(since_Id) "
        }
        if max_id > 0 {
            //上拉加载更多数据
            sql += "AND statusId < \(max_id) "
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20"
        print(sql)
        

       
        
        //执行查询的sql
        var statuses = [[String : AnyObject]]()
        
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            let r = try! db.executeQuery(sql, values: nil)
            //在结果集中查找下一条数据
            while r.next() {
//                let status = results.stringForColumn("status")
                //将字符串转换为字典数据
                //将进制数据  转换为字典数据
                //获取对应的字典数据   -> 获取存储的二进制数据 -> 将二进制数据转换为字典类型的数据
//                let dictData = results.dataForColumn("status")
                let dictData = r.data(forColumn: "status")
                guard let data = dictData else { return }
                let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                //将数据添加到数据中
                statuses.append(dict)
            }
        }
        
        //返回字典类型是数组
        return statuses
    }
    
    
    //存储网络数据
    class func saveStatus(array: [[String : AnyObject]]) {
        
        guard let userId = HMUserAccountViewModel.sharedAccountViewModel.userAccount?.uid else {
            print("用户暂未登录")
            return
        }
        //1. 先写sql
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,userId,status) VALUES (?,?,?);"
        //2.执行sql存储数据  inTransaction:开启 '事务' 来存储数据 -> 1.安全, 2.高效
        SQLiteManager.sharedManager.queue.inTransaction { (db, rollback) in
            //执行sql  来存储数据,字典数据是无法存储到数据库中的
            for item in array {
                //将微博的字典数据转换为二进制数据 存储到数据库中
                //将二进制数据存储到数据库中
                let statusData = try! JSONSerialization.data(withJSONObject: item, options: [])
                let statusId = item["id"]!
                try! db.executeUpdate(sql, values: [statusId,userId,statusData])

            }
            
            
        }
    }
}

