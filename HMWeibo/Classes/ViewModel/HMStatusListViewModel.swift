//
//  HMStatusListViewModel.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SDWebImage

class HMStatusListViewModel: NSObject {
    
    lazy var statusArray: [HMStatusViewModel] = [HMStatusViewModel]()
    
    
    func loadHomagePageData(isPullup: Bool, finished: @escaping (_ isSuccess: Bool) -> ()) {
        
        guard let token = HMUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token else {
            print("用户暂未登录")
            return
        }
        
        //上拉加载更多数据 max_id
        //加载更多数据  执行上拉操作
        //不能够同时制定since_id 和 max_id  这两个字段互斥的 只能够传一个
        var max_id: Int64 = 0
        var since_id: Int64 = 0
        //
        if isPullup {
            //上拉
            max_id = statusArray.last?.status?.id ?? 0
        } else {
            //下拉
            since_id = statusArray.first?.status?.id ?? 0
        }
        
        //使用数据处理层来加载数据  (有可能是缓存数据 有可能是网络数据)
        HMStatusDAL.loadHomeStatus(token: token, since_Id: since_id, max_id: max_id) { (result) in
            if result == nil {
                //数据获取失败 执行失败的回调
                finished(false)
            }
            //3.遍历数组
            //声明一个可变的数组
            var tempArray = [HMStatusViewModel]()
            for item in result! {
                //4.字典转模型
                let s = HMStatus(dict: item)
                let viewmodel = HMStatusViewModel(status: s)
                //5.将模型数据添加到数组中
                //可以达到 一个cell对应一个viewmodel
                tempArray.append(viewmodel)
            }
            //保存数组
            //self.statusArray = tempArray
            if isPullup {
                //上拉加载更多数据
                self.statusArray = self.statusArray + tempArray
            } else {
                //下拉刷新数据
                self.statusArray = tempArray + self.statusArray
            }
            
            //6.刷新tableView
            self.cacheSingleImage(array: tempArray, finished: finished)
        }
        

        
//        HMNetworkTools.sharedTools.loadHomePageData(token,max_id: max_id,since_id: since_id) { (result, error) -> () in
//            if error != nil {
//                finished(isSuccess: false)
//                return
//            }
//            //网络请求成功
////            print(result)
//            //1.将result 转换为字典类型
//            guard let dict = result as? [String : AnyObject] else {
//                finished(isSuccess: false)
//                return
//            }
//            //2.根据 statuses key 获取对应的字典类型的数组
//            guard let array = dict["statuses"] as? [[String : AnyObject]] else {
//                finished(isSuccess: false)
//                return
//            }
//            
//            //测试调用查询数据
//            let result = HMStatusDAL.checkOutStatus(since_id, max_id: max_id)
//        
//            print(result)
//            //测试调用存储 
//            HMStatusDAL.saveStatus(array)
//            
//            
//            
//            
//            
//            //3.遍历数组
//            //声明一个可变的数组
//            var tempArray = [HMStatusViewModel]()
//            for item in array {
//                //4.字典转模型
//                let s = HMStatus(dict: item)
//                let viewmodel = HMStatusViewModel(status: s)
//                //5.将模型数据添加到数组中
//                //可以达到 一个cell对应一个viewmodel
//                tempArray.append(viewmodel)
//            }
//            //保存数组
////            self.statusArray = tempArray 
//            if isPullup {
//                //上拉加载更多数据
//                self.statusArray = self.statusArray + tempArray
//            } else {
//                //下拉刷新数据
//                self.statusArray = tempArray + self.statusArray
//            }
//            
//            //6.刷新tableView
////            finished(isSuccess: true)
//            self.cacheSingleImage(tempArray, finished: finished)
//        }
    }
    
 
    //缓存单张图片到本地
    private func cacheSingleImage(array: [HMStatusViewModel],finished: @escaping (_ isSuccess: Bool) -> ()) {
        //判断数组的数量 
        if array.count == 0 {
            finished(true)
            return
        }
        //遍历模型数组
        let group = DispatchGroup()
        for s in array {
            //需要下载原创微博和转发微博的所有的 '单张' 图片
            if let pictures = s.status?.retweeted_status == nil ? s.status?.pic_urls : s.status?.retweeted_status?.pic_urls, pictures.count == 1 {
                //执行下载任务
                let url = URL(string: pictures.first?.thumbnail_pic ?? "")
                //异步任务
                //进入群组 任务+1
                group.enter()
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (_, _, _, _) in
                    //单张图片下载完毕
                    print("单张图片下载完毕")
                    group.leave()
                })
            }
        }
        
        //所有的图片下载完毕之后 执行回调
        group.notify(queue: DispatchQueue.main) {
            //执行回调
            print("所有的图片下载完毕")
            finished(true)
        }
    }
}
