//
//  UIBarButton+Extension.swift
//  LXWB
//
//  Created by lx on 2017/10/5.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

extension UIBarButtonItem{

    
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: imageName+"_highlighted"), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action:action , for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
}
