//
//  HomeTableViewCell.swift
//  LXWB
//
//  Created by lx on 2017/10/15.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SDWebImage
class HomeTableViewCell: UITableViewCell {
    
    
    /// 配图视图
    @IBOutlet weak var pictureCollectionView: LXPictureView!

    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 底部视图
    @IBOutlet weak var footerView: UIView!
    /// 转发正文
    @IBOutlet weak var forwardLabel: UILabel!

    ///模型数据
    var viewModel : StatusViewModel?{
        didSet{
           // LXLog("9 添加视图")

            //1.设置图像
         iconImageView.sd_setImage(with: viewModel?.icon_URL! as! URL, completed: nil)
            
            // 2.设置认证图标
         verifiedImageView.image=viewModel?.verified_image
            
            // 3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 4.设置会员图标
            
            //vipImageView.image=viewModel?.mbrankImage
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage
            {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            // 5.设置时间
            /**
             刚刚(一分钟内)
             X分钟前(一小时内)
             X小时前(当天)
             
             昨天 HH:mm(昨天)
             
             MM-dd HH:mm(一年内)
             yyyy-MM-dd HH:mm(更早期)
             */
            timeLabel.text = viewModel?.created_Time
            
            // 6.设置来源
            sourceLabel.text=viewModel?.source_Text
            
            // 7.设置正文
            contentLabel.text = viewModel?.status.text
            
            
            // 8.设置配图
            pictureCollectionView.viewModel = viewModel
            
                     
            // 9.处理转发微博正文
            if let text = viewModel?.forwardText{
                forwardLabel.text=text
                //设置最大宽度
                forwardLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * 10
            }
            
            
        }
    }
    
    
       ///MRAK : - 外部控制方法
    func calculateRowHeight(_ viewModel : StatusViewModel) -> CGFloat{
        
        //1.设置数据
        self.viewModel=viewModel
        
        //2.跟新UI
        self.layoutIfNeeded();
        
        //3.返回底部最大y值
       // LXLog(footerView.frame.maxY)
        return footerView.frame.maxY

    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置正文的最大宽度
        contentLabel.preferredMaxLayoutWidth=UIScreen.main.bounds.width - 2 * 10
        //设置头像得到圆角
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width * 0.5
        iconImageView.layer.masksToBounds = true
    
 
        
    }

}



