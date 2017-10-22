//
//  StatusViewModel.swift
//  LXWB
//
//  Created by lx on 2017/10/15.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
/*
 M: 模型(保存数据)
 V: 视图(展现数据)
 C: 控制器(管理模型和视图, 桥梁)
 VM:
 作用: 1.可以对M和V进行瘦身
 2.处理业务逻辑
 */
class StatusViewModel: NSObject {
    //模型对象
    var status : Status
    
    init(status : Status) {
       // LXLog("2.StatusViewModel模型执行")
        self.status=status
        
        //处理头像
        icon_URL = NSURL.init(string: (status.user?.profile_image_url)!)

        //处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        
        
        //处理认证图片
        if let type = status.user?.verified_type{
            var name = ""
            switch type{
            case 0:
                name = "avatar_vip" ;break;
            case 2, 3, 5:
                name = "avatar_enterprise_vip" ;break;
            case 220 :
                name = "avatar_grassroot"
            default : name = "" ; break;
            }
            verified_image=UIImage.init(named: name)
        }
    
        //处理来源
        if let sourceStr : NSString = status.source! as! NSString,  sourceStr != ""{
            // 6.1获取从什么地方开始截取
            let startIndex = sourceStr.range(of: ">").location + 1
            // 6.2获取截取多长的长度
            //                let length = sourceStr.rangeOfString("</").location - startIndex
            //                let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location -  startIndex
            
            // 6.3截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            
            source_Text = "来自: " + rest
        }


        //处理时间
        created_Time = "刚刚"
        
        if let timeStr = status.created_at {
            
            //let timeStrs = "Sun Dec 05 12:10:41 +0800 2014"
            //1.把服务器返回时间转换为Date
            let createDate = Date.createDate(timeStr: timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            //2.生成发布微博时间对应的字符串
            let result = createDate.descriptionStr()
            created_Time = result
        }
        
        //处理配图URL
        
        //1.从模型中取出去配图数组
        //判断有没有转发图片，有的话加在转发的配图 没有的话加载正文配图
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls
        {
            bmiddle_pic = [NSURL]()
            thumbnail_pic = [URL]()
            //2.遍历配图数组下载图片
            for dict in picurls
            {
                //2.1取出图片url字符串
                guard var urlStr = dict["thumbnail_pic"] as? String else
                {
                    //没有图片则执行下次循环
                    continue
                }
                let url = NSURL.init(string: urlStr)
                //拿到配图数组的url
                thumbnail_pic?.append(url! as URL)
                //2.2处理大图的url
                urlStr = urlStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
                bmiddle_pic?.append(NSURL.init(string: urlStr)!)

            }
        }
                
        
        
        // 处理转发正文
        if let text = status.retweeted_status?.text
        {
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
            
            
        }
        
    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图的URL
    var thumbnail_pic : [URL]?
    
    /// 保存所有配图大图URL
    var bmiddle_pic: [NSURL]?
    
    var bmiddle_str: [NSString]?
    
    /// 转发微博格式化之后正文
    var forwardText: String?
}
