//
//  WelcomeViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    /// 头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 头像容器
    @IBOutlet weak var iconImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.设置图片圆角
        iconImageView.layer.cornerRadius=45
        iconImageView.clipsToBounds=true
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权后才显示")
        
        //2.设置头像
        guard let url = URL.init(string: (UserAccount.account?.avatar_large)!) else {
            return
        }
        
        iconImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //1.让头像执行动画
        iconBottomCons.constant = (UIScreen.main.bounds.height-iconBottomCons.constant)
        
        UIView.animate(withDuration: 2.0, animations: {
            //重绘
            self.view.layoutIfNeeded()

        }) { (_) -> Void in
            
            UIView.animate(withDuration: 2.0, animations: { 
               self.titleLabel.alpha=1.0
            }, completion: { (_) -> Void in
                NotificationCenter.default.post(name: Notification.Name(rawValue : LXSwitchRootViewController), object: true)
                
            })
        }
        
        
        
    }


}
