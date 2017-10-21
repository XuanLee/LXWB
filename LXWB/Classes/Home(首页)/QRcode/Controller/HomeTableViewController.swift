//
//  HomeTableViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/3.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class HomeTableViewController: BaseTableViewController {
    /// 保存所有微博数据
    var statuses : [StatusViewModel]?
    /// 缓存行高
    var rowHeightCaches = [String : CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.判断用户是否登录
        if !isLogin
        {
            //1.1.设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue : LXPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self
            , selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue : LXPresentationManagerDidDismissed), object: animatorManager)
        
       //4.获取微博数据
        loadData()
        

       //5.设置tableView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        /*
         1.UIRefreshControl只要拉到一定程度无论是否松手会都触发下拉事件
         2.触发下拉时间之后, 菊花不会自动隐藏
         3.想让菊花消失必须手动调用endRefreshing()
         4.只要调用beginRefreshing, 那么菊花就会自动显示
         5.如果是通过beginRefreshing显示菊花, 不会触发下拉事件
         */

        refreshControl = LXRefreshControll()
        
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: UIControlEvents.valueChanged)
        
        refreshControl?.beginRefreshing()
        
        navigationController?.navigationBar.insertSubview(tipLable, at: 0)

    }
    
 
    
    //MARK: - 内部控制方法
    
    /*
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     默认情况下, 新浪返回的数据是按照微博ID从大到小得返回给我们的
     也就意味着微博ID越大, 这条微博发布时间就越晚
     经过分析, 如果要实现下拉刷新需要, 指定since_id为第一条微博的id
     如果要实现上拉加载更多, 需要指定max_id为最后一条微博id -1
     */

  @objc fileprivate func loadData(){

    
    var since_id = statuses?.first?.status.idstr ?? "0"
    var max_id = "0"
    //"https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00xwz2jGRJBxVE248553481ePkqmtB"
    if lastStatus{
        since_id = "0"
        max_id = (statuses?.last?.status.idstr)!
    }
    //避免下拉到最后一行 有重复数据
    let temp = (max_id != "0") ? "\(Int(max_id)! - 1)" : max_id
    // 1.准备路径
    let path = "2/statuses/home_timeline.json"
    // 2.准备参数
    let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!,
        "since_id" : since_id,
        "max_id" : temp
    ]
    // 3.发送get请求
    NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, obj) in
        
                //1.将字典数组转换为模型数组
                var models = [StatusViewModel]()
                guard let arr = (obj as! [String : AnyObject])["statuses"] as? [[String : AnyObject]] else{
                    return
                }
                for dict in arr{
                    let status = Status(dict: dict)
                    let viewModel = StatusViewModel.init(status: status)
                
                    models.append(viewModel)
                }
                //LXLog(models)
                //2.处理数据
                if since_id != "0"
                {
                    
                    self.statuses = models + self.statuses!
                }
            
                else if max_id != "0"
                {
                  self.statuses = self.statuses! + models
                }
                else
                {
                    self.statuses = models
                }
        
                //3.缓存图片数据 因为刷新表格之前 要先拿到图片
                self.cachesImages(models)
        
                //4.关闭菊花
                self.refreshControl?.endRefreshing()
        
                //5.显示刷新提醒
                self.showRefreshLabel(count: models.count)
        
    }) { (task, error) in
        LXLog("flase")
    }
    
    
}
    ///显示刷新提醒
    func showRefreshLabel(count : Int){
        
        //1.设置提醒文本
        tipLable.text = (count==0) ? "没有更多数据" : "刷新到\(count)条数据"
        tipLable.isHidden = false
        //2.执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLable.transform = CGAffineTransform(translationX: 0, y: 44)
        }) { (bool) in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions(rawValue : 0), animations: {
                self.tipLable.transform = CGAffineTransform.identity
            }, completion: { (bool) in
                self.tipLable.isHidden = true
            })
        }
    }
    // 缓存微博配图
    func cachesImages(_ viewModels:[StatusViewModel]){
      //  LXLog("3下载图片")
        //0 创建一个组
        let group = DispatchGroup()
        for viewModel in viewModels
        {
            //1.从模型中取出配图数据
           guard let picurls = viewModel.thumbnail_pic else
            {
                //没有图片则执行下次循环
                continue
            }
            //2.遍历数组下载图片
            for url in picurls
            {
                //将当前操作添加到组里面
                group.enter()
                //3运用SDWebImage下载图片
                SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions(rawValue: 0)
                    , progress: nil, completed: { (image, _, _, _, _, _) in
                       // LXLog("图片下载完成")
                        //将当前操作从组中移除
                        group.leave()
                })
            }
            
        }
        //监听下载操作
        group.notify(queue: DispatchQueue.main) { 
          //  LXLog("4全部下载完成")
            //刷新表格
            self.tableView.reloadData()
        }

    }
    
    

    
    func setupNav(){
        //2.1创建Nav俩边按钮
       navigationItem.leftBarButtonItem=UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
       navigationItem.rightBarButtonItem=UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        //2.2 创建titlebutton
        navigationItem.titleView=titleButton
    }
    
    
    //MARK: - 导航条按钮点击
    func titleChange(){
        titleButton.isSelected = !titleButton.isSelected
    }
    func leftBtnClick() -> Void {
        
    }
    
    func rightBtnClick() -> Void {
        //1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc=sb.instantiateInitialViewController()
        //2.弹出二维码控制器
        present(vc!, animated: true, completion: nil)
    }
    
    func titleBtnClick(){
        //创建下拉菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //自定义转场动画
        menuView.transitioningDelegate=animatorManager as UIViewControllerTransitioningDelegate
        
        //设置转场动画的样式
        menuView.modalPresentationStyle=UIModalPresentationStyle.custom
        
        
        //弹出菜单
        present(menuView, animated: true, completion: nil)
        
        
    }
    //MARK: - 懒加载
    fileprivate lazy var titleButton : TitleButton = {
        let btn = TitleButton()
        let name = UserAccount.account?.screen_name
        btn.setTitle(name, for: UIControlState())
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var animatorManager : LXPresentationManager = {
       let manger = LXPresentationManager()
         manger.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 300)
        return manger
    }()
    
    fileprivate lazy var tipLable : UILabel = {
       
        let ib = UILabel()
        ib.backgroundColor = UIColor.orange
        ib.text = "没有更多数据"
        ib.textColor = UIColor .white
        ib.textAlignment = NSTextAlignment.center
        let width = UIScreen.main.bounds.size.width
        ib.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        ib.isHidden = true
        return ib
    }()
    /// 最后一条微博标记
    public var lastStatus = false
}

extension HomeTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // LXLog("6 一组有多少行")
       return  self.statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // LXLog("----------------------8 设置cell数据")

        let viewModel = self.statuses![indexPath.row]
        //0.判断有没有转发微博，有的话用用forwardCell
        let identifier  = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        //1.取出cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeTableViewCell
        //2.设置数据
        cell.viewModel=viewModel
        
        // 判断是不是最后一条微博
        if indexPath.row == statuses!.count-1 {
            LXLog("最后一条微博")
            lastStatus = true
            loadData()
        }
        
        //3.返回cell
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        let viewModel = statuses?[indexPath.row]
        
        let identifier  = (viewModel?.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        // 1.从缓存中获取行高
        guard let height = rowHeightCaches[viewModel?.status.idstr ?? "-1"] else{
            
           // LXLog("计算行高")
            // 缓存中没有行高
            // 2.计算行高
            // 2.1获取当前行对应的cell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HomeTableViewCell
            
            
            //缓存行高
            let tmp = cell.calculateRowHeight(viewModel!)
            rowHeightCaches[viewModel?.status.idstr ?? "-1"] = tmp

            //返回行高
            return tmp;
        }
        
        return height;
    
    }


}


