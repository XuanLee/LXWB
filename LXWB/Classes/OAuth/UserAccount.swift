//
//  UserAccount.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/5.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    /// 令牌
    var access_token: String?
    
    /// 从授权那一刻开始, 多少秒之后过期时间
    var expires_in: Int = 0
    {
        didSet{
            // 生成正在过期时间
            expires_Date = Date(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    /// 真正过期时间
    var expires_Date: Date?
    
    /// 用户ID
    var uid: String?
    
    ///  用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    /// 用户昵称
    var screen_name: String?
    
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject])
    {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid", "expires_Date"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    // 归档模型
    func saveAccount() -> Bool
    {
        //是否归档是否保存
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /// 定义属性保存授权模型
    static var account: UserAccount?
    /// 归档文件路径
    static let filePath: String = "useraccount.plist".cachesDir()
    
    // 解归档模型
    class func loadUserAccount() -> UserAccount?
    {
        
        // 1.判断是否已经加载过了
        if UserAccount.account != nil{
            // 直接返回
            return UserAccount.account
        }
        //NJLog(UserAccount.filePath)
        print(UserAccount.filePath)
        // 2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else
        {
            return  nil
        }
        
        // 3.校验是否过期了
        /*
         guard let date = account.expires_Date else
         {
         return nil
         }
         // 2015  2016
         if date.compare(NSDate()) == NSComparisonResult.OrderedAscending
         {
         return nil
         }
         */
        
        // 2015 2016
        guard let date = account.expires_Date, date.compare(Date()) != ComparisonResult.orderedAscending  else
        {
           // NJLog("过期了")
            return nil
        }
        
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    
    /// 获取用户信息
    func loadUserInfo(_ finished: @escaping ( _ account: UserAccount?,  _ error: NSError?)->())
    {
        // 断言
        // 断定access_token一定是不等于nil的, 如果运行的时access_token等于nil, 那么程序就会崩溃, 并且报错
        assert(access_token != nil, "使用该方法必须先授权")
        
        // 1.准备请求路径
        let path = "2/users/show.json"
        // 2.准备请求参数
        let parameters = ["access_token": access_token!, "uid": uid!]
        
        
        NetworkTools.shareInstance.get(path, parameters: parameters, success: { (task, objc) in
            
            let dict = objc as! [String: AnyObject]
            
            // 1.取出用户信息
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            // 2.保存授权信息
            //            self.saveAccount()
            finished(self, nil)
        }) { (task, error) -> Void in
            finished(nil,error as NSError)
            //            print("error")
            
        }
        
        
        
        
    }
    
    /// 判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in") as Int
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? Date
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
}

