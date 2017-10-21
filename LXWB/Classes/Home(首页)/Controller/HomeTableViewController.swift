//
//  HomeTableViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.判断用户是否登录
        if !isLogin
        {
            //1.1.设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知
        NotificationCenter.default.addObserver(self, selector: Selector("titleChange"), name: NSNotification.Name(rawValue : LXPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self
            , selector: Selector("titleChange"), name: NSNotification.Name(rawValue : LXPresentationManagerDidDismissed), object: animatorManager)
        
       //4.获取微博数据
        loadData()
        

    }
    //MARK: - 内部控制方法
    
   fileprivate func loadData(){

    // 1.准备路径
    let path = "2/statuses/home_timeline.json"
    // 2.准备参数
    let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!]

//    NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, obj) in
//
//        //1.将字典数组转换为模型数组
//        var models = [Status]()
//        guard let arr = (obj as! [String : AnyObject])["status"] as? [[String : AnyObject]] else{
//            return
//        }
//        for dict in arr{
//            let status = Status(dict: dict)
//            models.append(status)
//        }
//        LXLog(models)
//        
//        
//    }) { (task, error) in
//        LXLog("false")
//        SVProgressHUD.showError(withStatus: "获取微博数据失败")
//    }
    
    
    NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, obj) in
        
        LXLog("true")
                //1.将字典数组转换为模型数组
                var models = [Status]()
                guard let arr = (obj as! [String : AnyObject])["statuses"] as? [[String : AnyObject]] else{
                    return
                }
                for dict in arr{
                    let status = Status(dict: dict)
                
                    models.append(status)
                }
                //LXLog(models)
        
    }) { (task, error) in
        LXLog("flase")
    }
    
    
}
    
    
    
    
    

    
    func setupNav(){
        //2.1创建Nav俩边按钮
       navigationItem.leftBarButtonItem=UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
       navigationItem.rightBarButtonItem=UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        //2.2 创建titlebutton
        navigationItem.titleView=titleButton
    }
    
    
    //MARK: - 导航条按钮点击
    func titleChange(){
        titleButton.isSelected = !titleButton.isSelected
    }
    func leftBtnClick() -> Void {
        
    }
    
    func rightBtnClick() -> Void {
        //1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc=sb.instantiateInitialViewController()
        //2.弹出二维码控制器
        present(vc!, animated: true, completion: nil)
    }
    
    func titleBtnClick(){
        //创建下拉菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //自定义转场动画
        menuView.transitioningDelegate=animatorManager as UIViewControllerTransitioningDelegate
        
        //设置转场动画的样式
        menuView.modalPresentationStyle=UIModalPresentationStyle.custom
        
        
        //弹出菜单
        present(menuView, animated: true, completion: nil)
        
        
    }
    //MARK: - 懒加载
    fileprivate lazy var titleButton : TitleButton = {
        let btn = TitleButton()
        let name = UserAccount.account?.screen_name
        btn.setTitle(name, for: UIControlState())
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var animatorManager : LXPresentationManager = {
       let manger = LXPresentationManager()
         manger.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 300)
        return manger
    }()
    

}
