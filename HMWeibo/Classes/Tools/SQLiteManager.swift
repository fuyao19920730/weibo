//
//  SQLiteManager.swift
//  FMDB演练
//
//  Created by heima on 16/4/20.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {

    //使用单例对象 
    static let sharedManager: SQLiteManager = SQLiteManager()
    
    //属性
    let queue: FMDatabaseQueue
    //私有化构造函数
    private override init() {
        
        //数据库文件一般存放在 沙盒路径中的 Document文件夹中
        //拼接路径的方法 在String 没有
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("status.db")
        //打开数据库连接 如果数据库不存在就创建数据库文件 并打开数据连接  如果数据库存在就直接 '连接' 数据库
        //打开连接之后就不会断开 为了提高访问效率
        queue = FMDatabaseQueue(path: path)
        
        super.init()
        createTable()
        print(path)
        
    }
    
    
    //执行sql 创建数据表
    private func createTable() {
        let sql = "CREATE TABLE IF NOT EXISTS T_Status (" +
        "statusId integer PRIMARY KEY NOT NULL," +
        "userId text NOT NULL," +
        "status text) ;"
        print(sql)
        queue.inDatabase { (db) -> Void in
            //使用db对象执行创建数据表的sql 创建对应的数据表
            if db.executeStatements(sql) {
                print("创建数据表成功")
            } else {
                print("创建数据表失败")
            }
        }
    }
    
    
}
