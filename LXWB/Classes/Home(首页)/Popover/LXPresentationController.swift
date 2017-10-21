//
//  LXPresentationController.swift
//  LXWB
//
//  Created by lx on 2017/10/5.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class LXPresentationController: UIPresentationController {
    /// 保存菜单的尺寸
    var presentFrame = CGRect.zero
    /*
     1.如果不自定义转场modal出来的控制器会移除原有的控制器
     2.如果自定义转场modal出来的控制器不会移除原有的控制器
     3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
     4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
     5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
     6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
    }
    
    //用户布局转场动画弹出来的控件
    override func containerViewWillLayoutSubviews() {
        
        presentedView?.frame=presentFrame
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(LXPresentationController.coverBtnClick), for: UIControlEvents.touchUpInside)
    }
    
    //MARK - 内部控制方法
    func coverBtnClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK - 懒加载
    fileprivate lazy var coverButton :UIButton = {
            let btn = UIButton()
        btn.frame=UIScreen.main.bounds
        btn.backgroundColor=UIColor.clear
        return btn
    }()
    
}
