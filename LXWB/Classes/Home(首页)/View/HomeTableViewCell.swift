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
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
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
            
            
            //8.跟新配图
            pictureCollectionView.reloadData()
            
            //9.更新配图尺寸
            let (itemSize,clvSize) = calculateSize()
            //9.1 更新cell尺寸
            if itemSize != CGSize.zero
            {
                flowLayout.itemSize = itemSize

            }
            
            // 9.2跟新collectionView尺寸
            //LXLog("clvSize \(clvSize.height)")
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
            
            //10 处理转发微博正文
            if let text = viewModel?.forwardText{
                forwardLabel.text=text
                //设置最大宽度
                forwardLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * 10
            }
            
            
        }
    }
    
    
        ///MRAK : - 外部控制方法
        //计算cell和collectionView的尺寸
    func calculateSize()->(cellSize:CGSize,CVSize:CGSize){
        
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
       // let count = viewModel?.status.pic_urls?.count ?? 0
        //新浪微博只返回一个图片数组,thumbnail_pic数组
        //有转发时外面直接返回viewModel_thumbnail_pic里面status.pic_urls 没图
        let count = viewModel?.thumbnail_pic?.count ?? 0

        // 没有配图
        if count == 0
        {
        return (CGSize.zero,CGSize.zero)
        }
        
        // 1张配图
        if count == 1
        {
//            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
//            let key = viewModel?.thumbnail_pic?.first?.absoluteString
//            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
//            SDWebImageManager.shared().diskImageExists(for: URL.init(string: key!), completion: { (b) in
//                LXLog("图片已经拿到")
//            })
            
             return (CGSize(width: 90, height: 90),CGSize(width: 90, height: 90))
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10

        // 4张配图
        // 展示2行2列
        if count == 4
        {
            let row = 2
            let col = 2
            
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))

        
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
extension HomeTableViewCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! HomePictureCell
        //        cell.backgroundColor = UIColor.redColor()
        
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
    
        return cell
    }
    
    
}
class HomePictureCell : UICollectionViewCell{
    
    var url: URL?
    {
        didSet
        {
            customIconImageView.sd_setImage(with: url)
        }
    }
    @IBOutlet weak var customIconImageView: UIImageView!

}


