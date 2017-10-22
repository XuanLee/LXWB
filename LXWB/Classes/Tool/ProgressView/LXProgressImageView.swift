//
//  LXProgressImageView.swift
//  LXWB
//
//  Created by lx on 2017/10/22.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class LXProgressImageView: UIImageView {

    var progress : CGFloat = 0.0{
        didSet{
            progressView.progress = progress
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    override func layoutSubviews() {
        //将progressView添加到imageView起始位置，针对自己坐标 所以为bounds
        progressView.frame = bounds

    }
    
    fileprivate func setUI(){
        
        addSubview(progressView)
              progressView.backgroundColor = UIColor.clear
    }
    
    //MARK - 懒加载
    fileprivate let progressView = LXProgressView()
}
