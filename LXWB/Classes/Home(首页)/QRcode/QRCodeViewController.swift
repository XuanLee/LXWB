//
//  QRCodeViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/5.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController {
    /// 扫描容器
    @IBOutlet weak var customContainerView: UIView!
    /// 底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    /// 结果文本
    @IBOutlet weak var customLabel: UILabel!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 容器视图高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.设置默认选中
        customTabbar.selectedItem=customTabbar.items?.first
        
        //2.监听底部工具条添加删除
        customTabbar.delegate=self as! UITabBarDelegate
        
        //3.开始扫描二维码
        scanQRCode()
    }
    
    func scanQRCode(){
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self as! AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        // 7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        // 8.开始扫描
        session.startRunning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }

    //MARK: - 内部控制方法
    /// 开启冲击波动画
    fileprivate func startAnimation()
    {
        // 1.设置冲击波底部和容器视图顶部对齐
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        // 2.执行扫描动画
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        })
        
    }
    
    ///打开相册
    @IBAction func photoBtnClick(_ sender: AnyObject) {
        // 1.判断是否能够打开相册
        /*
         case PhotoLibrary  相册
         case Camera 相机
         case SavedPhotosAlbum 图片库
         */

        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            return
        }
        
        //2.创建相册控制器
        let imagePickVc=UIImagePickerController()
        
        present(imagePickVc, animated: true, completion: nil)
        
        
    }
    
    ///关闭相册
    @IBAction func closeBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)

    }
    // MARK: - 懒加载
    /// 输入对象
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    /// 会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    /// 输出对象
    fileprivate lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.customContainerView.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        // 3.设置输出对象解析数据时感兴趣的范围
        //         out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        
        return out
    }()
    
    /// 预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    /// 专门用于保存描边的图层
    fileprivate lazy var containerLayer: CALayer = CALayer()

}
    
extension QRCodeViewController : UINavigationBarDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        NJLog(info)
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 2.3取出探测到的数据
        for result in results!
        {
            //NSLog((result as! CIQRCodeFeature).messageString)
            print((result as! CIQRCodeFeature).messageString!)
        }
        
        // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
        picker.dismiss(animated: true, completion: nil)
    }

}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    /// 只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        // 1.显示结果
        customLabel.text =  (metadataObjects.last as AnyObject).stringValue
        
        clearLayers()
        
        // 2.拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        // 通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        // 2.对扫描到的二维码进行描边
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
    }
    
    /// 绘制描边
    fileprivate func drawLines(_ objc: AVMetadataMachineReadableCodeObject)
    {
        
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }
        
        // 1.创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        // 2.创建UIBezierPath, 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        //        CGPointMakeWithDictionaryRepresentation((array[index] as! CFDictionary), &point)
        
        point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
        
        index+=1
        // 2.1将起点移动到某一个点
        path.move(to: point)
        
        // 2.2连接其它线段
        while index < array.count
        {
            //            CGPointMakeWithDictionaryRepresentation((array[index++] as! CFDictionary), &point)
            point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
            index+=1
            path.addLine(to: point)
        }
        // 2.3关闭路径
        path.close()
        
        layer.path = path.cgPath
        // 3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    fileprivate func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
}


extension QRCodeViewController: UITabBarDelegate
{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 根据当前选中的按钮重新设置二维码容器高度
        containerHeightCons.constant = (item.tag == 1) ? 100 : 200
        view.layoutIfNeeded()
        
        // 移除动画
        scanLineView.layer.removeAllAnimations()
        
        // 重新开启动画
        startAnimation()
    }
}


