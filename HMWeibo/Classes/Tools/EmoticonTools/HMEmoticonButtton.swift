//
//  HMEmoticonButtton.swift
//  EmoticonKeyBoard
//
//  Created by heima on 16/4/18.
//  Copyright © 2016年 heima. All rights reserved.
//

import UIKit

class HMEmoticonButtton: UIButton {

    //模型数据
    var em: HMEmoticon? {
        didSet {
            setImage(UIImage(contentsOfFile: em?.imagePath ?? ""), for: .normal)
            setTitle(em?.emojiStr, for: .normal)
            if let e = em, e.isDelete {
                //是删除按钮  直接给按钮设置图片
                setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }

}
