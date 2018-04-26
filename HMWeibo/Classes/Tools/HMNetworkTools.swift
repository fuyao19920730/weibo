//
//  HMNetworkTools.swift
//  3.Swift中网络的封装
//
//  Created by heima on 16/4/8.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import AFNetworking

//使用结构体来定义接口名称
struct API {
    //线上环境
    static let onlineHost = "https://api.weibo.com/"
    //测试环境  在上传AppStore之前 一定要取消使用这个环境
    static let devHost = "https://dev.api.weibo.com/"
    static let authrizon = "oauth2/access_token"
    static let access_token = "2/users/show.json"
    static let homepage = "2/statuses/home_timeline.json"
    static let sendStatus = "2/statuses/update.json"
    static let uploadImage = "https://upload.api.weibo.com/2/statuses/upload.json"
}

//swift 中的枚举
enum HMHttpMethods: String {
    case POST = "POST"
    case GET = "GET"
}

class HMNetworkTools: AFHTTPSessionManager {
    //声明单例对象
    static let sharedTools: HMNetworkTools = {
        let tools = HMNetworkTools(baseURL: URL(string: API.onlineHost))
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
}


//MARK: 登录和注册相关
extension HMNetworkTools {
    //MARK: 加载用户token
    func loadAccessToken(code: String, finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        //AFN中参数 以字典的形式传递
        let parameters = ["client_id":client_id,"client_secret":client_secret,"grant_type": "authorization_code","code":code,"redirect_uri":redirect_uri]
        //调用核心方法的
        request(method: .POST, urlString: API.authrizon, parameters: parameters as AnyObject, finished: finished)
    }
    
    //MARK: 加载用户的信息
    func loadUserInfo(token: AnyObject, uid: AnyObject,finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        //字典数组中不能够添加nil
        let parameters = ["access_token": token, "uid": uid]
        request(method: .GET, urlString: API.access_token, parameters: parameters as AnyObject, finished: finished)
    }
}

//MARK: 首页数据相关
extension HMNetworkTools {
    func loadHomePageData(token: String,max_id: Int64,since_id: Int64,finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        var parameters = ["access_token": token]
        if max_id > 0 {
            //max_id - 1解决数据重复的问题
            parameters["max_id"] = "\(max_id - 1)"
        }
        if since_id > 0 {
            parameters["since_id"] = "\(since_id)"
        }
        request(method: .GET, urlString: API.homepage, parameters: parameters as AnyObject, finished: finished)
    }
}

//MARK: 发布微博
extension HMNetworkTools {
    func sendStatus(token:String, status: String,imageList: [UIImage] = [UIImage](),finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        let parameters = ["access_token": token, "status": status]
        if imageList.count > 0 {
            //发布图片微博
            //如何上传图片
            //AFN
            post(API.uploadImage, parameters: parameters, constructingBodyWith: { (formdata) -> Void in
                //
                /**
                *将要上传的二进制数据添加到formdata
                *
                *  @param data  要上传的二进制数据
                *  @param name  服务器接收上传文件的字段名
                *  @param fileName  服务器获取到文件之后 以什么名称存储  名字可以随便取,新浪微博会按照自己的命名规则命名
                *  @param mimeType   文件类型
                *
                *  @return
                */
                // 第一个 '!' 表示一定获取一张图片  第二个 '!' 一定要将获取的图片转换 二进制
                
                for (index,image) in imageList.enumerated() {
                    let imageData = UIImagePNGRepresentation(image)!
                    formdata.appendPart(withFileData: imageData, name: "pic", fileName: "xxxxxx\(index)", mimeType: "image/jpeg")
                }
                
                }, progress: nil, success: { (_, result) -> Void in
                    finished(result, nil)
                }, failure: { (_, error) -> Void in
                    finished(nil, error)
            })
        } else {
            //发布文本微博
            request(method: .POST, urlString: API.sendStatus, parameters: parameters as AnyObject, finished: finished)
        }
    }
}





//MARK: 网络请求的核心方法 以后所以的get 和 post都走这个方法
extension HMNetworkTools {
    //封装所有的网络请求方法 所有的网络请求都是通过这个方法和 AFN进行联系
    func request(method: HMHttpMethods,urlString: String, parameters: AnyObject?, finished:  @escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        //swift中就不能够使用利用协议 欺骗Xcode
        //为了达到封装的目的 可以将相同的闭包 抽取出来,当做参数传递给AFN框架
        let success =  { (task: URLSessionDataTask, result: Any?) -> Void in
            //执行成功的回调
            finished(result, nil)
        }

        //定义失败的回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> Void in
            //执行失败的回调
            print(error)
            finished(nil, error)
        }
        
        if method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }

}
