//
//  HMStatusViewModel.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//  对应单个cell 处理cell显示的数据的逻辑

import UIKit
import YYText


class HMStatusViewModel: NSObject {
    
    //微博表情的正则表达式对象
    static let emoticonRegex = try! NSRegularExpression(pattern: "\\[.*?\\]", options: [])
    //话题的正则表达式对象
    static let topicRegex = try! NSRegularExpression(pattern: "#.*?#", options: [])
    
    //@某人正则表达式对象
    static let atSomeOneRegex = try! NSRegularExpression(pattern: "@\\w+", options: [])
    
    //url的正则表达式对象
    static let urlRegex = try! NSRegularExpression(pattern: "(http[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?", options: [])
    
    //在初始化方法 或者didSet内部给 status赋值 不会调用didSet
    var status: HMStatus?
    //模型中的 mbrank不能够直接用于视图显示 需要进行额外的处理
    var mbImage: UIImage?
    //认证类型的图片
    //在初始化的时候 在init方法中会被赋值 以后再调用 就会在内存中获取 消耗内存 但是不消耗cpu
    var verifiedImage: UIImage?
    
    //转发的文字
    var repostTitle: String?
    //评论的文字
    var commentTitle: String?
    //赞的文字
    var ohYeahTitle: String?
    
    //每次使用都会执行 消耗cpu
    var headImageURL: URL?
    
    //微博来源
    var source: String?
    //微博时间  只读属性(计算型属性)
    var time: String? {
        return Date.sinaDate(dateString: status?.created_at ?? "")?.fullDescription()
    }
    
    //原创微博正文的属性文本
    var originalAttributeString: NSAttributedString?
    
    //转发微博正文的属性文本
    var retweetedAttributeString: NSAttributedString?
    
    init(status: HMStatus) {
        super.init()
        //记录参数
        self.status = status
        //给headImageURL赋值
        headImageURL = URL(string: status.user?.profile_image_url ?? "")
         //用户等级
        dealmbRank()
        //用户的认证类型
        dealVerifiedType()
        
        dealWeiboSource()
        
        //处理微博正文
        originalAttributeString = dealWeiboText(source: status.text ?? "")
        //处理转发微博正文
        retweetedAttributeString = dealWeiboText(source:  status.retweeted_status?.text ?? "")
        repostTitle = dealToolBarText(count: status.reposts_count , defaultTitle: "转发")
        commentTitle = dealToolBarText(count: status.comments_count , defaultTitle: "评论")
        ohYeahTitle = dealToolBarText(count: status.attitudes_count , defaultTitle: "赞")
    }
}


//处理微博数据
extension HMStatusViewModel {
    
    private func dealWeiboText(source text: String) -> NSMutableAttributedString {
        //通过正则表达式来匹配对应的字符
        let results = HMStatusViewModel.emoticonRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        //遍历数组  取出对应的range  截取子串
        let strM = NSMutableAttributedString(string: text)
        //11代发货的北方[怒]大部分😄
        //倒序只需要替换一次就OK
        let textFont =  UIFont.systemFont(ofSize: WeiboContentLabelFont)
        for res in results.reversed() {
            let range = res.range(at: 0)
            let subStr = (text as NSString).substring(with: range)
            print(range,subStr)
            //获取了表情模型之后 可以将表情图片转换 属性字符串
            if let em = findEmoticonWithEmoticoText(subStr: subStr) {
                // [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter]
                let image = UIImage(contentsOfFile: em.imagePath ?? "")
                let imageText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFit, attachmentSize: CGSize(width: WeiboContentLabelFont, height: WeiboContentLabelFont), alignTo: textFont, alignment: .center)
//                let imageText = HMEmoticonAttachment.emoticonImageToAttributeString(em, font:textFont)
                //将属性文本进行替换
                strM.replaceCharacters(in: range, with: imageText)
            }
        }
        
        //给属性文本添加对应的属性
        strM.addAttribute(NSAttributedStringKey.font, value: textFont, range: NSRange(location: 0, length: strM.length))
        //设置属性文本的颜色
        strM.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: strM.length))
        //给属性字符串中的话题添加不同的颜色
        addHighlightedWithRegex(regex: HMStatusViewModel.topicRegex, strM: strM)
        addHighlightedWithRegex(regex: HMStatusViewModel.atSomeOneRegex, strM: strM)
        //url的正则匹配
        addHighlightedWithRegex(regex: HMStatusViewModel.urlRegex, strM: strM)
        return strM
        
    }
    
    
    //给话题添加不同的颜色
    private func addHighlightedWithRegex(regex regex: NSRegularExpression, strM: NSMutableAttributedString) {
        //1.查找话题字符串  正则表达式对象
        let sourceText = strM.string
        //匹配话题子串
        let results = regex.matches(in: sourceText, options: [], range: NSRange(location: 0, length: sourceText.characters.count))
        //遍历结果
        for res in results {
            let range = res.range(at: 0)
            let subStr = (sourceText as NSString).substring(with: range)
            print(subStr)
            //给属性文本对应的range 添加前景色的属性
            strM.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
            
            let border = YYTextBorder(fill: UIColor.red, cornerRadius: 4)
            
            border.insets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
            let highlighted = YYTextHighlight()
            //设置文本在高亮状态下的 颜色
            highlighted.setColor(UIColor.green)
            // BackgroundBorder 背景颜色
            highlighted.setBackgroundBorder(border)
            //设置高亮的背景颜色
            strM.yy_setTextHighlight(highlighted, range: range)
        }
    }
    
    //根据表情字符串查找对应的表情模型  -> 获取表情图片的路径
    private func findEmoticonWithEmoticoText(subStr: String) -> HMEmoticon? {
        //1.获取表情数据源  获取分组表情模型
        for p in HMEmoticonManager.sharedEmoticon.packages {
            //获取每个cell对应的表情数组
            for emoticons in p.sectionEmoticon {
                //在数组中模型的chs == subStr
                let array = emoticons.filter({ (em) -> Bool in
                    return em.chs == subStr
                })
                
                if array.count != 0 {
                    return array.first
                }
            }
        }
        
        return nil
    }
    
    
    //处理微博来源  <a href=\"http://app.weibo.com/t/feed/5yvsgq\" rel=\"nofollow\">TCL乐玩2C</a>
    private func dealWeiboSource() {
        let startFlag = "\">"
        let endFlag = "</"
        let str = status?.source ?? ""
        if let startRange = str.range(of: startFlag), let endRange = str.range(of: endFlag) {
            let range = startRange.upperBound..<endRange.lowerBound
            source = str.substring(with: range)
        }
    }
    
    //根据数量计算文字 如果大于0 就显示数量 如果 <= 0 就显示原有的文字
    private func dealToolBarText(count: Int, defaultTitle: String) -> String {
        //测试数据
//        let count = 121000
        if count <= 0 {
            return defaultTitle
        }
        if count > 10000 {
            return "\(Double(count / 1000) / 10)万"
        }
        return "\(count)"
    }
    
    private func dealmbRank() {
        let mbType = status?.user?.mbrank ?? 0
        if mbType > 0 && mbType < 7 {
            mbImage = UIImage(named: "common_icon_membership_level\(mbType)")
        }
    }
    
    private func dealVerifiedType() {
        //用户认证类型
        let verifiedType = status?.user?.verified ?? -1
        switch verifiedType {
        case 1:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }

    }
}
