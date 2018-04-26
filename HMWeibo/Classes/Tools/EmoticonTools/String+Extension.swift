//
//  String+Extension.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/17.
//  Copyright © 2016年 heima. All rights reserved.
//

import Foundation


extension String {
    func emojiStr() -> String {
        //Emoji表情本身就是字符串
        //1. 从字符串中查找十六进制的字符串
        let scanner = Scanner(string: self )
        //2.将十六进制的字符串转换为十六进制的整数
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        //3.将十六进制的整数 转换 unicode字符
        let code = Character(UnicodeScalar(value)!)
        //        print(code)
        //4.将字符转换字符串
        return "\(code)"
    }

}
