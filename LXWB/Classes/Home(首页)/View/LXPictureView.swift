//
//  LXPictureView.swift
//  LXWB
//
//  Created by lx on 2017/10/21.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SDWebImage
class LXPictureView: UICollectionView

{
    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource=self
        self.delegate=self
        
    }
    
    var viewModel : StatusViewModel?{
        didSet{
            
            reloadData()
            // 更新配图尺寸
            let (itemSize,clvSize) = calculateSize()
            // 更新cell尺寸
            if itemSize != CGSize.zero
            {
                flowLayout.itemSize = itemSize
                
            }
            // 跟新collectionView尺寸
            //LXLog("clvSize \(clvSize.height)")
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width

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
}
extension LXPictureView : UICollectionViewDataSource
,UICollectionViewDelegate{
    
    
    ///MARK- CollectionViewDataScore
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! HomePictureCell
        //        cell.backgroundColor = UIColor.redColor()
        
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
        
        return cell
    }
    
    
    ///MARK - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //0.获取当前被点击cell的url
        let url = viewModel?.bmiddle_pic?[indexPath.item]
        
        //取出被点击的cell
        let cell = collectionView.cellForItem(at: indexPath) as! HomePictureCell
        
        //1.下载图片，设置进度
        SDWebImageManager.shared().loadImage(with: url! as URL, options: SDWebImageOptions(rawValue : 0), progress: { (curren, total, _) in
            
            cell.customIconImageView.progress = CGFloat(curren) / CGFloat(total)
            
        }) { (_, _, error, _, _, _) in
            // 2.弹出一个控制器(图片浏览器), 告诉控制器哪些图片需要展示, 告诉控制器当前展示哪一张
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LXShowPhotoBrowserController), object: nil, userInfo: ["bmiddle_pic":self.viewModel?.bmiddle_pic!,"indexPath":indexPath])
        }
        LXLog( viewModel?.bmiddle_pic?[indexPath.item])
    }
}



class HomePictureCell : UICollectionViewCell{
    
    var url: URL?
    {
        didSet
        {
            customIconImageView.sd_setImage(with: url)
            
         
            //控制GIF图片的隐藏
         if let flag = url?.absoluteString.lowercased().hasSuffix("gif")
         {
                gifImageView.isHidden = !flag
         }
            
        }
    }
    @IBOutlet weak var customIconImageView: LXProgressImageView!
    @IBOutlet weak var gifImageView : UIImageView!
    
}
