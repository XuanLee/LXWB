//
//  NewfeatureViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SnapKit
class NewfeatureViewController: UIViewController {
    /// 新特性界面的个数
    fileprivate var maxCount = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
extension NewfeatureViewController: UICollectionViewDataSource
{
    
    // 1.告诉系统有多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // 2.告诉系统每组多少行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    // 3.告诉系统每行显示什么内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! LXNewfeatureCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.purple
        // 2.设置数据
        cell.index = indexPath.item
        
        // 3.返回cell
        return cell
    }
}


extension NewfeatureViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 注意: 传入的cell和indexPath都是上一页的, 而不是当前页
        // 1.手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last!
        LXLog(index.item)
        // 2.根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItem(at: index) as! LXNewfeatureCell
        // 3.判断当前是否是最后一页
        if index.item == (maxCount - 1)
        {
            // 做动画
            currentCell.startAniamtion()
        }
    }
}

// MARK: - 自定义Cell

class LXNewfeatureCell: UICollectionViewCell {

    var index: Int = 0
{
    didSet{
    
    // 1.生成图片名称
    let name = "new_feature_\(index + 1)"
    // 2.设置图片
    iconView.image = UIImage(named: name)
    startButton.isHidden = true
    }
}
    
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // 初始化UI
    setupUI()
}
    
    // MARK: - 外部控制方法
    func startAniamtion()
{
    startButton.isHidden = false
    // 执行放大动画
    startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    startButton.isUserInteractionEnabled = false
    UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
    self.startButton.transform = CGAffineTransform.identity
    
    }, completion: { (_) -> Void in
    self.startButton.isUserInteractionEnabled = true
    })
    }
    
    // MARK: - 内部控制方法
    fileprivate func setupUI()
{
    // 1.添加子控件
    contentView.addSubview(iconView)
    contentView.addSubview(startButton)
    
    //  2.布局子控件
    iconView.snp_makeConstraints { (make) -> Void in
    make.edges.equalTo(0)
    }
    
    startButton.snp_makeConstraints { (make) -> Void in
    make.centerX.equalTo(contentView)
    make.bottom.equalTo(contentView).offset(-160)
    }
    }
    
    @objc fileprivate func startBtnClick()
    {
    // 跳转到首页
    /*
     let sb = UIStoryboard(name: "Main", bundle: nil)
     let vc = sb.instantiateInitialViewController()!
     UIApplication.sharedApplication().keyWindow?.rootViewController = vc
     */
    NotificationCenter.default.post(name: Notification.Name(rawValue: LXSwitchRootViewController), object: true)
    }
    
    
    // MARK: - 懒加载
    /// 图片容器
    fileprivate lazy var iconView = UIImageView()
    
    /// 开始按钮
    fileprivate lazy var startButton: UIButton = {
//    let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        
        let btn = UIButton()
    btn.setBackgroundImage(UIImage.init(named: "new_feature_button"), for: UIControlState.normal)
        
        
        
    btn.addTarget(self, action: #selector(LXNewfeatureCell.startBtnClick), for: UIControlEvents.touchUpInside)
    return btn
    }()
}
// MARK: - 自定义布局
class LXNewfeatureLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepare() {
        // 1.设置每个cell的尺寸
        itemSize = UIScreen.main.bounds.size
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 4.设置分页
        collectionView?.isPagingEnabled = true
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
