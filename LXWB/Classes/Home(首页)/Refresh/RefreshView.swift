//
//  RefreshView.swift
//  LXWB
//
//  Created by lx on 2017/10/19.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SnapKit
class LXRefreshControll: UIRefreshControl {

    override init() {
        super.init();
        //1.添加子控件
        addSubview(refreshView)
        //2.布局子控件
        refreshView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.center.equalTo(self)
        }
        //3.监听UIRefreshControl frame 变化
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }

    //标记是否需要旋转
    var rotationFlag = false
    
    ///MARK: - 内部控制方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //过滤垃圾数据
        if frame.origin.y == 0 || frame.origin.y == -64{
            return
        }
        
        //判断是否触摸下拉刷新事件 拉到一定距离
        if isRefreshing{
            //隐藏视图,显示加载视图,并让菊花转动
            refreshView.startLoadingView()
            return
        }
        
        
        //越往下拉 y值越小 往上拉y值越大
        if frame.origin.y < -50 && !rotationFlag
        {
            rotationFlag=true
            
            LXLog("向上旋转")
            
            refreshView.rotationArrow(flag: rotationFlag)
            
        }
        else if frame.origin.y > -50 && rotationFlag{
            
            rotationFlag=false
            
            LXLog("向下旋转")
            
            refreshView.rotationArrow(flag: rotationFlag)
                    
        }
       //  LXLog(frame)
    }
    
    deinit {
        
        removeObserver(self, forKeyPath: "frame")
        
    }
    
    
    override func endRefreshing() {
        super.endRefreshing()
        //结束时停止加载动画
        refreshView.stoploadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -懒加载
    private lazy var refreshView: RefreshView = RefreshView.CreateRefreshView()
}
class RefreshView: UIView {
    /// 菊花
    @IBOutlet weak var loadingImageView: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    class func CreateRefreshView() ->RefreshView {
        
        return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)?.first as! RefreshView;
    }
    
    // MARK: - 外部控制方法
    /// 旋转箭头
    func rotationArrow(flag: Bool)
    {
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        /*
         transform旋转动画默认是按照顺时针旋转的
         但是旋转时还有一个原则, 就近原则
         */
        UIView.animate(withDuration: 1.0) { () -> Void in
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: angle)
        }
    }
    
    /// 显示加载视图
    func startLoadingView()
    {
        
        //0.隐藏提示视图
        tipView.isHidden = true
        
        if let _ = loadingImageView.layer.animation(forKey: "LX")
        {
            //如果已经添加动画就直接返回
            return
        }
        
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        //2.设置动动画属性
        //转360度
        anim.toValue = 2 * M_PI
        
        anim.duration = 5.0
        
        //动画播放次数
        anim.repeatCount = MAXFLOAT
        
        //将动画添加到图层上
        loadingImageView.layer.add(anim, forKey: "LX")
        
    }
    
    
    
    ///隐藏加载视图
    func stoploadView(){
        //0.显示提示视图
        tipView.isHidden = false
        //1.移除动画
        loadingImageView.layer.removeAllAnimations();
    }
}
