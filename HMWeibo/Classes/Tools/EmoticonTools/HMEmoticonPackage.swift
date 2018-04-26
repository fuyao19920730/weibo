//
//  HMEmoticonPackage.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
//在这个模型中处理数据
//package模型中 应该提供什么  [[HMEmoticon]]

//每页显示21个表情
let EmoticonPageCount = 21
let EmoticonColCount = 7
let EmoticonRowCount = 3
let HMEmoticonBtnDidClick = "HMEmoticonBtnDidClick"

class HMEmoticonPackage: NSObject {
    
    var name: String?
    lazy var sectionEmoticon = [[HMEmoticon]]()
    init(id: String,name: String,array: [[String : String]]) {
        self.name = name
        super.init()
        
        //遍历数组 将数组中字典先转换为模型数据  -> [HMEmoticon]
        var tempArray = [HMEmoticon]()
        
        for (index,item) in array.enumerated() {
             //每页的最后一个添加一个删除的模型
            let e = HMEmoticon(id:id,dict: item)
            tempArray.append(e)
            if (index + 1) % 20 == 0 {
                //添加一个删除按钮对应的模型
                let delete = HMEmoticon(isDelete: true)
                tempArray.append(delete)
            }
        }
        
        //已经操作完成过后的数据 看每一页是否会有装不满的情况, 需要按照每页21个表情补足剩余空表情
        let delta = tempArray.count % 21
        if delta > 0 {
            for _ in delta..<20 {
                //添加空白模型
                let empty = HMEmoticon(isEmpty: true)
                tempArray.append(empty)
            }
            //添加完空白表情后 添加一个删除按钮对应的模型
            let delete = HMEmoticon(isDelete: true)
            tempArray.append(delete)
        }
        
        
        
        //将得到的模型数组 在处理分组表情数组  -> [[HMEmoticon]]
        sectionEmoticon = sectionEmoticons(array: tempArray)
    }
    
    
    //将[HMEmoticon]类型数组 处理成 [[HMEmoticon]]
    private func sectionEmoticons(array: [HMEmoticon]) -> [[HMEmoticon]] {
        //在 [HMEmoticon]类型数组中截取子数组 长度是 21 
        //1.算出能够截取几页  分页截取数组
        let pageCount = (array.count - 1) / EmoticonPageCount + 1
        //分页截取数组
        var sectionArr = [[HMEmoticon]]()
        for i in 0..<pageCount {
            
            let loc = i * EmoticonPageCount
            var length = EmoticonPageCount
            //84 + 21 = 105  > 102
            if loc + length > array.count {
                //更改长度 length = 102 - 84
                length = array.count - loc
            }
            let subArray = (array as NSArray).subarray(with: NSRange(location: loc, length: length))
            sectionArr.append(subArray as! [HMEmoticon])
        }
        
        return sectionArr
    }
}
