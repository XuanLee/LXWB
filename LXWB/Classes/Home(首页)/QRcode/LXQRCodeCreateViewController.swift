//
//  LXQRCodeCreateViewController.swift
//  LXWB
//
//  Created by lx on 2017/10/5.
//  Copyright © 2017年 lx小. All rights reserved.
//

import UIKit

class LXQRCodeCreateViewController: UIViewController {
    //二维码容器
    @IBOutlet weak var customImageVivew: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2.还原滤镜默认属性
        filter?.setDefaults()
        // 3.设置需要生成二维码的数据到滤镜中
        // OC中要求设置的是一个二进制数据
        filter?.setValue("李徐安".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        // 4.从滤镜从取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else
        {
            return
        }
        
        //        customImageVivew.image = UIImage(CIImage: ciImage)
        customImageVivew.image = createNonInterpolatedUIImageFormCIImage(ciImage, size: 500)

        
    }

    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }

}
