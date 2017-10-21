//
//  BaseTableViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
/*
 通知 : 层级结构较深
 代理 : 父子 , 方法较多时候使用
 block: 父子, 方法较少时使用(一般情况一个方法)
 */
class BaseTableViewController: UITableViewController {

   
        
        //定义标记记录用户登录状态
        var isLogin = UserAccount.isLogin()
        
        //设置访客视图
        var visitorView :VisitorView?
        
        override func loadView() {
            // 判断用户是否登录, 如果没有登录就显示访客界面, 如果已经登录就显示tableview
            isLogin ? super.loadView() : setupVisitorView()
        }
        
        // MARK: - 内部控制方法
         func setupVisitorView()
        {
            // 1.创建访客视图
            visitorView = VisitorView.visitorView()
            view = visitorView
            
            // 2.设置代理
            visitorView?.loginButton.addTarget(self, action: Selector(("loginBtnClick:")), for: UIControlEvents.touchUpInside)
            visitorView?.registerButton.addTarget(self, action: Selector(("registerBtnClick:")), for: UIControlEvents.touchUpInside)
            
            // 3.添加导航条按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("registerBtnClick:")))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("loginBtnClick:")))
        }
        
        
        
        
    

    /// 监听登录按钮点击
  @objc fileprivate func loginBtnClick(_ btn: UIButton)
    {
        let sb=UIStoryboard(name: "OAuth", bundle: nil)
        let vc=sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    /// 监听注册按钮点击
   @objc fileprivate  func registerBtnClick(_ btn: UIButton)
    {
    }

}
