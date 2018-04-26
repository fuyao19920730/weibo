//
//  HMEmoticonTextView.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/18.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMEmoticonTextView: UITextView {

    //插入表情图片 和相关的操作
    func insertEmotioncText(em: HMEmoticon) {
        //点击空表情
        if em.isEmpty {
            print("空表情啥都不做")
            return
        }
        
        if em.isDelete {
            //执行回删
            deleteBackward()
            return
        }
        
        if em.code != nil {
            //表示用户点击是Emoji表情  将用户输入的文本插入到光标选中的位置
//            replace(selectedRange, withText: em.emojiStr ?? "")
            return
        }
        
        
        //程序走到这里 表示用户点击的一定是表情图片
        //NSTextAttachment 附件类型
        let imageText = HMEmoticonAttachment.emoticonImageToAttributeString(em: em, font: font!)
        //3.将当前textView的属性文本转换可变的属性文本   -> strM
        let strM = NSMutableAttributedString(attributedString: attributedText)
        //4.将带有图片的属性文本替换到可变的strM当中
        //在替换之前记录之前选中的光标
        let range = selectedRange
        strM.replaceCharacters(in: selectedRange, with: imageText)
        
        //5.重新设置textView的属性文本
        attributedText = strM
        
        //6.恢复之前选中的光标
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        //主动使用代理对象调用协议方法 
        self.delegate?.textViewDidChange?(self)
    }
    
    
    
    //将属性文本转换为纯文本
    func showFullText() -> String {
        var strM = String()

        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedStringKey.attachment] as? HMEmoticonAttachment{
                //是图片
                strM += attachment.chs ?? ""
            } else {
                //是文字
                
                let subStr = (self.text as NSString).substring(with: range)
                strM += subStr
            }
        }
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dict, range, _) -> Void in
            
        }
        return strM
    }

}
