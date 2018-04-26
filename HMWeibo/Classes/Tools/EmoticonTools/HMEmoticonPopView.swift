//
//  HMEmoticonPopView.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/18.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMEmoticonPopView: UIView {

    @IBOutlet weak var emoticonButton: HMEmoticonButtton!
    
    
    //加载当前视图
    class func loadPopView() -> HMEmoticonPopView {
        let v = Bundle.main.loadNibNamed("HMEmoticonPopView", owner: nil, options: nil)?.last as! HMEmoticonPopView
        return v
    }
    
    
    func show(button btn: HMEmoticonButtton) {
        if btn.em!.isDelete || btn.em!.isEmpty {
            //不添加popView
            //移除popView
            isHidden = true
            return
        }
        let lastWindow = UIApplication.shared.windows.last!
        //设置布局
        self.emoticonButton.em = btn.em
        //添加到cell 上
        if self.superview != lastWindow {
            lastWindow.addSubview(self)
        }
        isHidden = false
        //设置frame
        //转换坐标 将 btn 的坐标转换到window
        //        let rect = __.convertRect(_rect(如果是自己在转化的时候就使用bounds,如果是父视图 就使用frame)_, toView: _需要转换到的目标视图_)
        let rect = btn.convert(btn.bounds, to: window)
        
        center.x = rect.midX
        frame.origin.y = rect.maxY - frame.height
        
    }
    
    func dimissAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            // your code here
            self.isHidden = true
        }
    }

}
