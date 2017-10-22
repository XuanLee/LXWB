//
//  BrowserViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/21.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SDWebImage
class BrowserViewController: UIViewController {

    /// 所有配图
    var bmiddle_pic: [NSURL]
    /// 当前点击的索引
    var indexPath: NSIndexPath
    
    init(bmiddle_pic: [NSURL], indexPath: NSIndexPath) {
        
       self.bmiddle_pic=bmiddle_pic
       self.indexPath = indexPath
//        LXLog("\(bmiddle_pic)+\(indexPath)")
        // 注意: 自定义构造方法时候不一定是调用super.init(), 需要调用当前类设计构造方法(designated)

        super.init(nibName: nil, bundle: nil)
        //  布局子控件
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 内部控制方法
    fileprivate func setUI(){
        
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(saveButon)
        view.addSubview(closeButton)
        self.collectionView.dataSource = self

        
        //2.布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButon.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["closeButton": closeButton, "saveButton": saveButon]
        let closeHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeButton(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let closeVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(closeHCons)
        view.addConstraints(closeVCons)
        
        let saveHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let saveVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(saveHCons)
        view.addConstraints(saveVCons)
    }
    @objc private func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc private func saveBtnClick()
    {
        
    }
    //MARK: - 懒加载
    fileprivate let  collectionView : UICollectionView = {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXBrowserLayout())
       // clv.dataSource = self as? UICollectionViewDataSource
        
        clv.register(LXBrowserCell.self, forCellWithReuseIdentifier: "browserCell")
        clv.backgroundColor = UIColor.red
        return clv
    }()
    
    fileprivate let closeButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState.normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(BrowserViewController.closeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate let saveButon : UIButton  = {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState.normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(BrowserViewController.saveBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
}

extension BrowserViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pic.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browserCell", for: indexPath) as! LXBrowserCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        
        cell.imageURl = bmiddle_pic[indexPath.item]
        return cell
    }
    
}

class LXBrowserLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        itemSize = UIScreen.main.bounds.size
        
        //同一组当中，垂直方向：行与行之间的间距；水平方向：列与列之间的间距
        minimumInteritemSpacing = 0
         //垂直方向：同一行中的cell之间的间距；水平方向：同一列中，cell与cell之间的间距
        minimumLineSpacing = 0
        // 水平滚动
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        //分页效果隐藏
        collectionView?.isPagingEnabled = true
        //反弹
        collectionView?.bounces = false
        //不显示垂直滚动条
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.showsHorizontalScrollIndicator = true
    }
    
    
}
class LXBrowserCell: UICollectionViewCell,UIScrollViewDelegate {
    
    var imageURl : NSURL?{
        didSet{
            
            //显示菊花提醒
            indicatorView.startAnimating()
            
            //因为cell会重用，每次更改的off insert size 会被cell重用
            resetView()
            
            //下载图片
            //图片下载完成时改变frame
            imageView.sd_setImage(with: imageURl! as URL) { (image, error, _, _) in
             
                //关闭句话提醒
                self.indicatorView.stopAnimating()

                let width = UIScreen.main.bounds.size.width
                let height = UIScreen.main.bounds.size.height
                
                
                //1.计算当前图片的宽高比
                
                let scale = (image?.size.height)! / (image?.size.width)!
                
                //2.利用宽高比乘屏幕宽度
                let imageHeight = width * scale
                
                //3.设置图片frame
                self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: imageHeight)
                
                //判断是长图还是短图
                if imageHeight < height{
                    //短图
                    //4.计算scorellView顶部和底部内边距
                    let offY = (height - imageHeight) * 0.5
                    
                    //5.设置内边距
                    self.scrollview.contentInset = UIEdgeInsets(top: offY, left: 0, bottom: offY, right: 0)
                    
                }
                else {//长图
                    //设置scrollView内容尺寸
                    self.scrollview.contentSize = CGSize(width: width, height: imageHeight)
                }
                
            }
        }
    }


    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        //布局子控件
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 内部控制方法
    fileprivate func resetView(){
        scrollview.contentInset = UIEdgeInsets.zero
        scrollview.contentOffset = CGPoint.zero
        scrollview.contentSize = CGSize.zero
    }
    fileprivate func setUI(){
     
        contentView.addSubview(scrollview)
        scrollview.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        scrollview.frame = UIScreen.main.bounds
        scrollview.backgroundColor = UIColor.darkGray
        scrollview.delegate = self as UIScrollViewDelegate
        
        indicatorView.center = contentView.center
    }
    
    //MARK:- ScrollViewDataScore
    //告诉系统那个view要缩放
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    //缩放过程中会不停调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
      let width = UIScreen.main.bounds.size.width
      let height = UIScreen.main.bounds.size.height

      //计算内边距 需要拿到imageView.frame 相当于 contentSize
      //如果bounds 每次缩放 值不会该改变
      
        //1.计算上下边距
        var offsetY = (height - imageView.frame.height) * 0.5
        // 2.计算左右内边距
        var offsetX = (width - imageView.frame.width) * 0.5
        
        //如果边距等于负的 就相当于限定了滚动的范围 倒是图片不能滚动
        
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        
        scrollview.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)

    }
    
    
    

    //MARK: - 懒加载
    fileprivate lazy var  scrollview : UIScrollView = {
        let sc = UIScrollView()
        sc.minimumZoomScale = 0.5
        sc.maximumZoomScale  = 2.0
        return sc
    }()
    fileprivate lazy var imageView = UIImageView()
    
    // 显示提示视图
    fileprivate lazy var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
}
