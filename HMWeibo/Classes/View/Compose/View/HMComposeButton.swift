//
//  HMComposeButton.swift
//  HMWeibo
//
//  Created by heima on 16/4/14.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit
//contentRect = (0,0,80,110)
private let imageW: CGFloat = 80
class HMComposeButton: UIButton {
 
    var composeItem: HMComposeItem? {
        didSet {
            setTitle(composeItem?.title, for: .normal)
            setImage(UIImage(named: composeItem?.icon ?? ""), for: .normal)
        }
    }
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: imageW, height: imageW)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: imageW, width: imageW, height: contentRect.size.height - imageW)
    }
}
