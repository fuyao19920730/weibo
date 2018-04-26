//
//  UILabel+Extension.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String,textColor: UIColor,fontSize: CGFloat,margin: CGFloat = 0) {
        self.init()
        self.text = text
        self.textColor = textColor
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        //设置居中
        textAlignment = .center
        if margin > 0 {
            //设置 最大显示的宽度
            preferredMaxLayoutWidth = ScreenWidth - 2 * margin
            textAlignment = .left
        }
        //设置 最大显示的宽度
        //        l.preferredMaxLayoutWidth = 230
        //自适应大小
        sizeToFit()
    }
}
