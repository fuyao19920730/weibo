//
//  HMEmoticonAttachment.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/18.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMEmoticonAttachment: NSTextAttachment {

    //表情图片附件对象对应的表情文本
    var chs: String?
    
    
    //将表情转换为属性文本
    class func emoticonImageToAttributeString(em: HMEmoticon,font: UIFont) -> NSAttributedString{
        //NSTextAttachment 附件类型
        let attachment = HMEmoticonAttachment()
        //1.给附件对象添加图片
        attachment.image = UIImage(contentsOfFile: em.imagePath ?? "")
        attachment.chs = em.chs
        let lineHeight = font.lineHeight
        //scrollView contentOffset 就是 视图的bounds
        attachment.bounds = CGRect(x: 0, y: -4, width:lineHeight, height: lineHeight)
        //2.通过附件对象 得到一个属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        //不可变的属性文本是不能添加属性的
        imageText.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: 1))
        return imageText
    }
}
