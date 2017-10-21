//
//  NetworkTools.swift
//  LXWB
//
//  Created by lx on 2017/10/10.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import AFNetworking
class NetworkTools: AFHTTPSessionManager{
    
    //Swift 建议我们这样写单例
    static let shareInstance : NetworkTools = {
        // 注意: baseURL后面一定更要写上./
        let baseURL = URL(string: "https://api.weibo.com/")!
        
        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: URLSessionConfiguration.default)
        
        instance.responseSerializer.acceptableContentTypes = (NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as! Set)
        
        return instance

    }()
    
    
    //MARK: -外部控制方法
//    //在NetworkTools 提供一个获取微博数据方法 网络请求成功则返回闭包
//    func loadStatuses (_ finished: @escaping (_ array : [String:AnyObject]?, _ error :NSError)->()) {
//        
//        assert(UserAccount.loadUserAccount() != nil, "必须授权成功才能获取微博数据")
//        
//        
//        // 1.准备路径
//        let path = "2/statuses/home_timeline.json"
//        // 2.准备参数
//        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!]
//        LXLog(UserAccount.loadUserAccount()!.access_token!)
//        // 3.发送GET请求
////        get(path, parameters: parameters, success: { (task, obj) in
////            //返回数据给调用者
////            guard  let arr = (obj as! [String : AnyObject])["statuses"] as? [String : AnyObject] else{
////                finished(nil, NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message": "没有获取到数据"]))
////                return
////            }
////            
////            finished(arr, Error.self as! NSError)
////            
////        }) { (task, error) in
////            finished(nil, error as NSError)
////
////        }
//        
//        
//        get("https://api.weibo.com/2/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task, obj) in
//            LXLog("true");
//        }) { (task, error) in
//            LXLog("false")
//        }
//        
//        
//        
//        
//        
//        
//        
//    }
    
}
