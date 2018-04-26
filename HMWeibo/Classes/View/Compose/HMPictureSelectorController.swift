//
//  HMPictureSelectorController.swift
//  HMWeibo
//
//  Created by heima on 16/4/15.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
import SnapKit
import HMImagePicker

//每个cell之间的间距
private let cellMarigin: CGFloat = 3
private let colCount: CGFloat = 4
//最大可选的图片张数
private let maxImageCount = 9

private let PicturSelectorCellId = "PicturSelectorCellId"

class HMPictureSelectorController: UICollectionViewController {

    //保存添加的图片
    lazy var imageList: [UIImage] = [UIImage]()
    private var selectedAsset: [PHAsset]?
    
    init() {
        //设置流水布局
        let itemW = (ScreenWidth - (colCount + 1) * cellMarigin) / colCount
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = cellMarigin
        layout.minimumLineSpacing = cellMarigin
        layout.sectionInset = UIEdgeInsets(top: cellMarigin, left: cellMarigin, bottom: 0, right: cellMarigin)
        layout.itemSize = CGSize(width: itemW, height: itemW)
        super.init(collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(PictureSelectorCell.self, forCellWithReuseIdentifier: PicturSelectorCellId)
    }
}

extension HMPictureSelectorController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let detla = imageList.count >= maxImageCount ? 0 : 1
        return imageList.count + detla
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturSelectorCellId, for: indexPath) as! PictureSelectorCell
        
        cell.backgroundColor = randomColors
        //指定代理
        cell.selectorDelegate = self
        
        if indexPath.item == imageList.count {
            //程序走到这个地方  如果去数组根据索引取值 就会造成数组索引越界
            cell.image = nil
        } else {
            cell.image = imageList[indexPath.item]
        }
        
        return cell
    }
}

extension HMPictureSelectorController: PictureSelectorCellDelegate{
    func userWillChosePicture() {
        print("VC中 添加")
        //图片选择器
        
        
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//            let picker = UIImagePickerController()
////            picker.allowsEditing = true
//            //设置代理
//            picker.delegate = self
//            presentViewController(picker, animated: true, completion: nil)
//        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //使用框架
            let picker = HMImagePickerController(selectedAssets: selectedAsset)
            //设置代理
            picker.pickerDelegate = self
            picker.targetSize = CGSize(width: 600, height: 600)
            picker.maxPickerCount = maxImageCount
            present(picker, animated: true, completion: nil)
        }
        
        /*
        HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
        
        // 设置图像选择代理
        picker.pickerDelegate = self;
        // 设置目标图片尺寸
        picker.targetSize = CGSizeMake(600, 600);
        // 设置最大选择照片数量
        picker.maxPickerCount = 9;
        
        [self presentViewController:picker animated:YES completion:nil];
        */
    }
    
    
    func userWillDeletePicture(cell: PictureSelectorCell) {
        //1.获取用户点击的是哪一个cell
        //通过协议方法的参数获取用户点击的cell
        //2.获取cell对应的indexPath
        if let indexPath = collectionView?.indexPath(for: cell) {
            //3.在数组中移除对应 indexPath.item 对应的元素
            imageList.remove(at: indexPath.item)
            //删除上一次选择图片的数据源
            self.selectedAsset?.remove(at: indexPath.item)
            //刷新数据
            collectionView?.reloadData()
        }
        
    }

}

extension HMPictureSelectorController: HMImagePickerControllerDelegate {
    func imagePickerController(_ picker: HMImagePickerController, didFinishSelectedImages images: [UIImage], selectedAssets: [PHAsset]?) {
        self.imageList = images
        self.selectedAsset = selectedAssets
        self.collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
        /*
        // 记录图像，方便在 CollectionView 显示
        self.images = images;
        // 记录选中资源集合，方便再次选择照片定位
        self.selectedAssets = selectedAssets;
        
        [self.collectionView reloadData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        */
    }
}

//extension HMPictureSelectorController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    //一旦实现了协议方法之后 图片选择器的消失 就交给程序员来管理
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        print(image)
//        print(editingInfo)
//        imageList.append(image)
//        
//        //修改了数据源之后 就应该刷新数据
//        self.collectionView?.reloadData()
//        
//        //保存选择选择的图片
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//}


@objc protocol PictureSelectorCellDelegate: NSObjectProtocol {
    //d定义协议方法 
    @objc optional func userWillChosePicture()
    
    //用户将要删除图片
    @objc optional func userWillDeletePicture(cell: PictureSelectorCell)
}

class PictureSelectorCell: UICollectionViewCell {
    
    
    var image: UIImage? {
        didSet {
            //给按钮设置图片
            deleteBtn.isHidden = image == nil
            addBtn.setImage(image, for: .normal)
        }
    }
    //定义代理对象 弱引用
    weak var selectorDelegate: PictureSelectorCellDelegate?
    
    
    @objc private func addBtnDidClick() {
        //使用代理对象 调用协议方法
        
        if image != nil {
            print("已经有图了,不要再加了 ")
            return
        }
        
        
         selectorDelegate?.userWillChosePicture?()
        
    }
    
    @objc private func deleteBtnDidClick() {
        selectorDelegate?.userWillDeletePicture?(cell: self)
        print("用户删除")
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
        contentView.addSubview(addBtn)
        contentView.addSubview(deleteBtn)
        addBtn.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp.edges)
        }
        
        deleteBtn.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        //给按钮添加点击事件
        
        addBtn.addTarget(self, action: #selector(addBtnDidClick), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnDidClick), for: .touchUpInside)
    }
    
    //懒加载子视图
    private lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), for: .highlighted)
        
        return btn
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), for: .normal)
        
        return btn
    }()
}
