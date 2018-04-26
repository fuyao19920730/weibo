
//
//  HMStatusPictureView.swift
//  HMWeibo
//
//  Created by heima on 16/4/12.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SDWebImage

private let pictrueCellId = "pictrueCellId"
/// 图片直接的间距
private let pictureCellMargin: CGFloat = 3
private let maxWidth = ScreenWidth - 2 * StatusCellMargin
private let itemWidth = (maxWidth - 2 * pictureCellMargin) / 3

class HMStatusPictureView: UICollectionView {
    
    //外界设置的模型数组
    var imageURLs: [HMStatusPicture]? {
        didSet {
            //根据模型数组的数量 计算配图视图的大小
//            print(imageURLs?.count)
            let pSize = caculatePictureViewSize()
            //更新视图的大小
            self.snp.updateConstraints { (make) -> Void in
                make.size.equalTo(pSize)
            }
            
            ///更新测试数据
            testLabel.text = "\(imageURLs?.count ?? 0)"
            
            //刷新页面的数据
            self.reloadData()
        }
    }
    
    
    //根据配图的数量计算配图的大小
    //1.单张图片显示图片原比例尺寸
    //2.四张图片  2 * 2 
    //3. 其他的张图片就按照 3 * n(根据图片数量来计算)
    private func caculatePictureViewSize() -> CGSize {
        
        let imageCount = imageURLs?.count ?? 0
        //没有图片
        if imageCount == 0 {
            return CGSize.zero
        }
        //获取固定值
        
        //单张图片
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if imageCount == 1 {
            //TODO 后期完善
            //SDWebImage 3.7.4版本之后 根据屏幕的scale 来缩放图片
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: imageURLs?.first?.thumbnail_pic ?? "")
            print(image?.scale ?? "")
            let scale = UIScreen.main.scale
            let imageSize = CGSize(width: (image?.size.width)! * scale, height: (image?.size.height)! * scale)
            //将layout的itemsize设置和配图一般大
           
            layout.itemSize = imageSize
            return imageSize
        }
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //四张图片
        if imageCount == 4 {
            let w = itemWidth * 2 + pictureCellMargin
            return CGSize(width: w, height: w)
        }
        
        //程序走到这里 一定是 其他的多张图片
        /*
        1,2,3   - 1
        4,5,6,  - 2
        7,8,9   - 3
        */
        let row = CGFloat((imageCount - 1) / 3 + 1)
        let h = row * itemWidth + (row - 1) * pictureCellMargin
        return CGSize(width: maxWidth, height: h)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = pictureCellMargin
        layout.minimumLineSpacing = pictureCellMargin
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
        //注册cell
        self.register(PictureCell.self, forCellWithReuseIdentifier: pictrueCellId)
        //设置数据源代理
        self.dataSource = self
        //设置代理
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp.center)
        }
    }
    
    private lazy var testLabel: UILabel = UILabel(text: "", textColor: UIColor.red, fontSize: 30)

}

//MARK: 数据源方法
extension HMStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //注册cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictrueCellId, for: indexPath) as! PictureCell
        //设置测试时yanse
//        cell.backgroundColor = randomColor()
        cell.statusPicture = imageURLs![indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        let browser = SDPhotoBrowser()
        browser.sourceImagesContainerView = self
        browser.imageCount = imageURLs?.count ?? 0
        browser.currentImageIndex =  indexPath.item
        browser.delegate = self
        browser.show()
        
        /*
        创建SDPhotoBrowser实例
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        
        browser.sourceImagesContainerView = 原图的父控件;
        
        browser.imageCount = 原图的数量;
        
        browser.currentImageIndex = 当前需要展示图片的index;
        
        browser.delegate = 代理;
        
        [browser show]; // 展示图片浏览器
        */
    }
    
}

extension HMStatusPictureView:  SDPhotoBrowserDelegate {
    //返回 高质量的图片的url对象
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        //根据index 获取indexPath  -> 在数组中获取 对象
        let indexPath = NSIndexPath.init(item: index, section: 0)
        let picture = imageURLs![indexPath.item]
        //将缩略图的字符串 转换为高清图片的url字符串
        if let urlString = picture.thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "bmiddle") {
            let url  = URL(string: urlString)
            
            return url
        }
        return nil
    }
    
    
    //返回缩略图的image对象
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        //返回图片
        //1.获取indexPaht
        let indexPath = NSIndexPath.init(item: index, section: 0)
        //获取对应cell
        if let cell = self.cellForItem(at: indexPath as IndexPath) as? PictureCell {
            //返回cell的iconView.image
            
            return cell.iconView.image
        }
        return nil
        
    }
}


class PictureCell: UICollectionViewCell {
    
    
    var statusPicture: HMStatusPicture? {
        didSet {
            //给图片赋值
            let url = URL(string: statusPicture?.thumbnail_pic ?? "")
            iconView.sd_setImage(with: url)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置UI界面
    private func setupUI() {
        contentView.addSubview(iconView)
        //设置约束
        iconView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    //懒加载子视图
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        
        //设置填充模式
        iv.contentMode = .scaleAspectFill
        //手写代码需要手动设置裁剪
        iv.clipsToBounds = true
        return iv
        
    }()
}
