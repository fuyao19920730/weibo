//
//  HMEmoticon.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

//单个表情模型
class HMEmoticon: NSObject {

    //分组文件名称
    var id: String?
    
    //在向服务器发送表情的时候传递表情文本
    var chs: String?
    
    //显示在文本输入框中的图片
    var png: String? {
        didSet {
            //给 imagePath 赋值
//            imagePath = bundle路劲 + Emoticons.bundle + 文件夹名(id) + 图片名称
            imagePath = Bundle.main.bundlePath + "/Emoticons.bundle/" + "\(id!)/" + "\(png ?? "")"
        }
    }
    
    var imagePath: String?
    
    //十六进制的字符串
    var code: String? {
        didSet {
            emojiStr = code?.emojiStr()
        }
    }
    
    var emojiStr: String?
        
//        {
//        return code?.emojiStr()
//    }
    
    //标记是否是删除按钮的模型
    var isDelete = false
    
    //标记是否是空白按钮的模型
    var isEmpty = false
    
    init(id: String,dict: [String : String]) {
        self.id = id
        super.init()
        setValuesForKeys(dict)
    }
    
    init(isDelete: Bool) {
        super.init()
        self.isDelete = isDelete
    }
    
    init(isEmpty: Bool) {
        super.init()
        self.isEmpty = isEmpty
    }
    
    //过滤
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //MARK: 将对象转化为字符串
    override var description: String {
        let keys = ["chs","png","code","emojiStr"]
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict.description
    }
}
