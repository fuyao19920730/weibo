//
//  HMEmoticonManager.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

/*

负责加载表情数据

*/

import UIKit

class HMEmoticonManager: NSObject {

    static let sharedEmoticon: HMEmoticonManager = HMEmoticonManager()
    
    lazy var packages = [HMEmoticonPackage]()
    
    //私有化构造函数 不让外界访问,在外界创造对象
    private override init() {
        super.init()
        loadAllEmoticons()
    }
    //加载所有的表情数据
    func loadAllEmoticons() {
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let packages = dict["packages"] as! [[String : AnyObject]]
        print(packages)
        //遍历数组
        for item in packages {
            let id = item["id"] as! String
            //根据id加载分组表情文件夹中 info.plist文件
            loadSectionEmoticon(id: id)
        }
    }
    
    
    private func loadSectionEmoticon(id: String) {
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/" + id)!
        //获取info.plist文件对应的字典数据
        let dict = NSDictionary(contentsOfFile: path)!
        let name = dict["group_name_cn"] as! String
        let array = dict["emoticons"] as! [[String : String]]
        let p = HMEmoticonPackage(id: id, name: name, array: array)
        //将分组模型添加到数组中
        packages.append(p)
    }
}
