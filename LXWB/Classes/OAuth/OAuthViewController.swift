//
//  OAuthViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/10.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    /// 网页容器
    @IBOutlet weak var customWebView: UIWebView!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.定义字符串保存登录界面URL
         let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        
        //2.创建url
        guard  let url = NSURL(string: urlStr) else
        {
            return
        }
        
        //3.创建Request
        let request = NSURLRequest(url: url as URL)
        
        //4.加载登录界面
        customWebView.loadRequest(request as URLRequest)
        
        
    }
    
    //MARK: -内部控制方法
   
    @IBAction func closeBtnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func autoBtnClick(){
        
    }

}

extension OAuthViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "正在等待中")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    //每次请求页面都会调用这个方法
    //true 代表允许请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.判断当前是否是授权回调页面
        guard  let urlStr = request.url?.absoluteString else {
            return false
        }
        
        //如果不包含回调页面 请求成功
        if !urlStr.hasPrefix(WB_Redirect_uri)
        {
            return true
        }

        // 2.判断授权回调地址中是否包含code=
        let key = "code=" as NSString
        guard let str = request.url!.query else
        {
            return false
        }
        
        if str.hasPrefix(key as String)
        {
            let code = (str as NSString).substring(from: 5)
            loadAccessToken(codeStr: code)
            return false
        }
        return false

    }
    
    fileprivate func loadAccessToken(codeStr : String?){
        guard let code = codeStr else
        {
            return
        }
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let path = "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        
        // 3.发送POST请求
        
        NetworkTools.shareInstance.post(path, parameters: parameters, success: { (task, objc) in
            print("true")
           // print(path)
            // 1.将授权信息转换为模型
            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            // 2.获取用户信息
            account.loadUserInfo({ (account, error) -> () in
                // 3.保存用户信息
                account?.saveAccount()
                // 4.跳转到欢迎界面
                
                NotificationCenter.default.post(name: NSNotification.Name( rawValue: LXSwitchRootViewController), object: true)
                // 关闭界面
                self.closeBtnClick()
            })
            
            print("授权成功")
        }) { (task, error) -> Void in
            print(error)
            //NJLog(error)
        }
    }
}



