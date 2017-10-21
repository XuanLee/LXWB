//
//  NSData+Extension.swift
//  LXWB
//
//  Created by lx on 2017/10/15.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

extension Date{
    //根据一个字符串创建NSDate
    static func createDate(timeStr: String, formatterStr: String) -> Date{
        //1.将服务器返回的时间转换为NSDate
        //日期格式化对象
        let formatter = DateFormatter()
        
        formatter.dateFormat="EE MM dd HH:mm:ss Z yyyy"
        
        //如果不指定以下代码 在真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        return formatter.date(from: timeStr)!

    }
    
    //生成当前时间对应的字符串
     func descriptionStr() -> String
    {
        // 1.创建时间格式化对象
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        // 创建一个日历类
        let calendar = NSCalendar.current
        /*
         // 该方法可以获取指定时间的组成成分 |
         let comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: createDate)
         NJLog(comps.year)
         NJLog(comps.month)
         NJLog(comps.day)
         */
        //结果
        var result = ""
        //为了更改日期合适的临时Str
        var formatterStr = "HH:mm"
        
        if calendar.isDateInToday(self){
            //今天
            //3.比较两个时间的差值 当前时间跟模型的值做比较
            let inerval = Int(NSDate().timeIntervalSince(self))
            if inerval < 60
            {
                result = "刚刚"
            }else if inerval < 60 * 60
            {
                result = "\(inerval / 60)分钟前"
            }else if inerval < 60 * 60 * 24
            {
                result = "\(inerval / (60 * 60))小时前"
            }
        }else if calendar.isDateInYesterday(self){//昨天
            // 昨天
            formatterStr = "昨天 " + formatterStr
            formatter.dateFormat = formatterStr
            result = formatter.string(from: self)
        }
        else {
            //获取更早之间的差值
            
            let comps = calendar.dateComponents([Calendar.Component.year], from: self, to: NSDate() as Date)
            //取出相差的年份
            let year = comps.year
            if year! > 1{
                // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            }
            else
            {//一年内
                formatterStr = "MM-dd" + formatterStr
                
            }
            formatter.dateFormat=formatterStr
            //通过日期格式化对象formatter 把当前时间转换为Str
            result=formatter.string(from: self)
        }

        return result
    }
    
    
    
    
}
