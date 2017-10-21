//
//  VisitorView.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    /// 注册按钮
    @IBOutlet weak var registerButton: UIButton!
    /// 登录按钮
    @IBOutlet weak var loginButton: UIButton!
    /// 转盘
    @IBOutlet weak var rotationImageView: UIImageView!
    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    /// 文本标签
    @IBOutlet weak var titleLabel: UILabel!
    
    
   //给外界提供一个快速创建的方法
   
    class func visitorView() ->VisitorView{
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.last as! VisitorView
    }
    
    
    /// 设置访客视图上的数据
    /// imageName需要显示的图标
    /// title需要显示的标题
    
    
    func setupVisitorInfo(_ imageName : String? , title : String) -> Void {
        //1.设置标题
        titleLabel.text=title;
        
        //2.是不是首页
        guard let name=imageName else {
            
            startAniamtion()
            return
        }
        //3.设置其他数据
        //不是首页
        rotationImageView.isHidden=true
        iconImageView.image=UIImage.init(named: name)
    }
    
    // MARK: - 内部控制方法
    /// 转盘旋转动画
    
    
    fileprivate func startAniamtion(){

        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation");
        
        //2.设置动画属性
        anim.toValue = 2 * M_PI
        //5秒旋转一圈
        anim.duration=5.0
        //不停旋转
        anim.repeatCount=MAXFLOAT
        
        
        //注意：默认情况下只要视图消失，系统就会自动移除动画
        //只有设置removedOnCompletion 为false，系统就不会移除动画
        
        anim.isRemovedOnCompletion=false;
        
        //3.将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
        
        
    }

}
