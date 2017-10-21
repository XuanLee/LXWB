//
//  ViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class LXMainViewControlle: UITabBarController {


    //view即将显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear");

        //1.添加加号按钮
        tabBar.addSubview(composeButton)
        
        //2.设置按钮尺寸
        let rect = composeButton.frame
        
        //计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        
        //计算按钮的位置
        composeButton.frame=CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    
    }
    

  @objc fileprivate func compseBtnClick(_ btn : UIButton){
        
        NSLog("xxx")
    }
    
    lazy var composeButton : UIButton = {
     
        let btn=UIButton()
        //设置前景图片
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        
        //设置背景图片
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: UIControlState.highlighted)
        
        //调整按钮尺寸
        btn.sizeToFit();
        
        //监听按钮点击
        btn.addTarget(self, action: #selector(LXMainViewControlle.compseBtnClick(_:)), for: UIControlEvents.touchUpInside)
        
        return btn;
    }()
    
    /*
     打印LOG的弊端:
     1.非常消耗性能
     2.如果app部署到AppStore之后用户是看不到LOG的
     
     所以
     开发阶段: 显示LOG
     部署阶段: 隐藏LOG
     */
    public func LXLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
    {
        #if DEBUG
            //    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
            print("\(methodName)[\(lineNumber)]:\(message)")
        #endif
    }

}

