//
//  HMStatusOriginalView.swift
//  HMWeibo
//
//  Created by heima on 16/4/11.
//  Copyright © 2016年 heima. All rights reserved.
//  原创微博部分的视图

import UIKit
import SnapKit
import YYText
import SDWebImage
import SVProgressHUD

let WeiboContentLabelFont: CGFloat = 15
let StatusCellMargin: CGFloat = 8
class HMStatusOriginalView: UIView {
    
    var bottomCons: Constraint?
    
    var statusViewModel: HMStatusViewModel? {
        didSet {
//            print(statusViewModel?.status?.retweeted_status?.text)
            //绑定模型数据
            iconView.sd_setImage(with: statusViewModel?.headImageURL)
            nameLabel.text = statusViewModel?.status?.user?.name
            //用户等级
            mbRankImageView.image = statusViewModel?.mbImage
            verifiedImageView.image = statusViewModel?.verifiedImage
            //设置时间
            //TODO 后期完善
            timeLabel.text = statusViewModel?.time
            sourceLabel.text = statusViewModel?.source
//            print(statusViewModel?.status?.created_at, statusViewModel?.status?.source)
//            contentLabel.text = statusViewModel?.status?.text
            contentLabel.attributedText = statusViewModel?.originalAttributeString
            //配图视图设置数据源
            self.bottomCons?.deactivate()
            if let urls = statusViewModel?.status?.pic_urls, urls.count > 0 {
                //有配图视图
                //更新约束
                self.snp.updateConstraints({ (make) -> Void in
                    self.bottomCons = make.bottom.equalTo(pictureView.snp.bottom).offset(StatusCellMargin).constraint
                })
                //设置数据源
                pictureView.imageURLs = urls
                //显示配图视图
                pictureView.isHidden = false
            } else {
                //没有配图视图
                //更新约束
                self.snp.updateConstraints({ (make) -> Void in
                    self.bottomCons = make.bottom.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin).constraint
                })
                //设置数据源 nil
                pictureView.imageURLs = nil
                //隐藏配图视图
                pictureView.isHidden = true

            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置UI
    private func setupUI() {
        backgroundColor = UIColor.white
        sepView.backgroundColor = UIColor.red
        //圆角的处理
        iconView.cornerRadius = 20
        addSubview(sepView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(mbRankImageView)
        addSubview(verifiedImageView)

        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(pictureView)
        
        sepView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self)
            make.height.equalTo(StatusCellMargin)
        }
        iconView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sepView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        
        mbRankImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargin)
        }
        
        verifiedImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(iconView.snp.right)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        sourceLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargin)
        }
        contentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(iconView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(iconView.snp.left)
        }
        
        pictureView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentLabel.snp.left)
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        
        //设置原创微博的底部相对微博正文的底部约束
        self.snp.makeConstraints { (make) -> Void in
            self.bottomCons = make.bottom.equalTo(pictureView.snp.bottom).offset(StatusCellMargin).constraint
        }
        
        
        //处理点击事件  如果点击的是url  就跳转页面
        contentLabel.highlightTapAction = { (containerView, text, range, rect) -> () in
            //将属性文本转换为字符串
            let str = text.string
            //截取子串 获取对应点击的字符串
            let subStr = (str as NSString).substring(with: range)
            SVProgressHUD.showInfo(withStatus: subStr)
            if subStr.contains("http") {
                //是url 跳转页面  视图不能够跳转页面
                let web = ViewController()
                web.urlString = subStr
                //跳转页面
                self.navController()?.pushViewController(web, animated: true)
            }
        }
    }
    
 /// 分隔条
    private lazy var sepView: UIView = UIView()
    
 /// 用户头像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
 /// 用户等级
    private lazy var mbRankImageView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
 /// 用户认证类型
    private lazy var verifiedImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
 /// 用户名
    private lazy var nameLabel: UILabel = UILabel(text: "15期的童鞋们", textColor: UIColor.darkGray, fontSize: 15)
 /// 微博时间
    private lazy var timeLabel: UILabel = UILabel(text: "15:15", textColor: UIColor.orange, fontSize: 12)
 /// 微博来源
    private lazy var sourceLabel: UILabel = UILabel(text: "隔壁老王", textColor: UIColor.darkGray, fontSize: 12)
 /// 微博正文
    private lazy var contentLabel: YYLabel = {
        let yy = YYLabel()
        //设置最大布局宽度
        //直接设置label的字号和颜色没有任何效果 应该给属性文本添加属性
//        yy.font = UIFont.systemFontOfSize(20)
        yy.preferredMaxLayoutWidth = ScreenWidth - 2 * StatusCellMargin
        //设置行数为自动换行
        yy.numberOfLines = 0
        return yy
    }()
    
//     UILabel(text: "我没有男胖呀", textColor: UIColor.darkGrayColor(), fontSize: WeiboContentLabelFont, margin: StatusCellMargin)
    //配图视图
    private lazy var pictureView: HMStatusPictureView = HMStatusPictureView()
}
