//
//  User.swift
//  LXWB
//
//  Created by lx on 2017/10/15.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    // 用户认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1

    // 会员等级 ,取值范围 1~6
    var mbrank: Int = -1
    
     init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
   
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
