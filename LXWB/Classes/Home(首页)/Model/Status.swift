//
//  Status.swift
//  LXWB
//
//  Created by lx on 2017/10/15.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
   /// 微博作者信息
    var user : User?
    
    ///  配图数组
    var pic_urls : [[String : AnyObject]]?
    
  
    /// 转发微博
    var retweeted_status: Status?
    
    init(dict : [String : AnyObject]) {
        super.init();
       setValuesForKeys(dict)
       // LXLog("1.status模型执行")
 
        
    }
    /// kvc内部调用setValue
    override func setValue(_ value: Any?, forKey key: String) {
        
        //拦截user赋值操作
        if key == "user" {
            user=User.init(dict: value as! [String : AnyObject])
            return
        }
        
        if key == "retweeted_status"
        {
            retweeted_status = Status(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    /// 找不到key 避免崩溃 重写这个方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        LXLog("找不到\(key)")
        
    }
    
    
    override var description: String{
        let property = ["created_at", "idstr", "text", "source"]
        let  dict = dictionaryWithValues(forKeys: property)

        return "\(dict)"
    }
    
}
