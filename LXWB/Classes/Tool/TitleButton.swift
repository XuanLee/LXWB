//
//  TitleButton.swift
//  LXWB
//
//  Created by lx on 2017/10/5.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

   
    //通过纯代码时候调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    //通过xib时候调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()

    }
    
    
  
    func setUI() -> Void {
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: UIControlState())
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        setTitleColor(UIColor .darkGray, for: UIControlState())
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle((title ?? "") + "  ", for: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.origin.x=titleLabel!.frame.width
        titleLabel?.frame.origin.x=0
    }
    

}
