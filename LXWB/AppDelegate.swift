//
//  AppDelegate.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().tintColor=UIColor.orange;
        
        
        //监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.changeViewController(_:)), name: NSNotification.Name(rawValue : LXSwitchRootViewController), object: nil)
        
        
        //设置默认控制器
        window=UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor=UIColor.white
        window?.rootViewController=defaultViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension AppDelegate{
    
    ///切换根控制器
    func changeViewController(_ notice : Notification){
        if(notice.object as! Bool){//true
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            window?.rootViewController=vc
        }
        else{
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }
    }
}
/// 用于返回默认界面

func defaultViewController() ->UIViewController{
    //1.判断是否登录
    if(UserAccount.isLogin()){
    
        //2.判断有没有新版本
        if isNewVersion() {
            let sb = UIStoryboard(name: "Newfeature", bundle: nil)
            return sb.instantiateInitialViewController()!
        }else
        {
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            return sb.instantiateInitialViewController()!
        }
        
    }
    // 没有登录
    let sb = UIStoryboard(name: "Main", bundle: nil)
    return sb.instantiateInitialViewController()!
}

fileprivate func isNewVersion() ->Bool{
    //1.加载info.plist
    //2.获取当前版本号
    let currentVerson = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    //3.获取以前的版本号
    let defaults = UserDefaults.standard
    let sanboxVersion = (defaults.object(forKey: "cewd") as? String) ?? "0.0"
    /*
     typedef enum _NSComparisonResult {
     NSOrderedAscending = -1,    // < 升序  num1<num2
     NSOrderedSame,              // = 等于
     NSOrderedDescending   // > 降序    num1>num2
     } NSComparisonResult;
     */
    if currentVerson.compare(sanboxVersion) == ComparisonResult.orderedDescending {
//        //升序  当前版本大于以前版本
//        LXLog("有新版本")
//        //更新版本号
        defaults.set(currentVerson, forKey: "cewd")
        defaults.synchronize() // iOS7以前需要写, iOS7以后不用写

        return true
   }
//    LXLog("没有新版本")

    return false
}







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
       // #if DEBUG
            //    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
            print("\(methodName)[\(lineNumber)]:\(message)")
        //#endif
    }
   




