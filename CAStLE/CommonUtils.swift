//
//  CommonUtils.swift
//  Bite Me
//
//  Created by Rafi Rizwan on 1/9/16.
//  Copyright © 2016 BiteCode, LLC. All rights reserved.
//

import UIKit

class CommonUtils: NSObject {
    //MARK: Image Utils
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func UIColorFromRGBHex(hex: String!) -> UIColor{
        let temp = UIColor.clearColor()
        
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.startIndex.advancedBy(1)
            let hexColor = hex.substringFromIndex(start)
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    let result = UIColor(red: r, green: g, blue: b, alpha: a)
                    return result
                }
            }
        }
        return temp
    }
    
    func scaleImage(image: UIImage, scaledHeight: CGFloat, scaledWidth: CGFloat) -> UIImage {
        
        let scaledSize = CGSize(width: scaledWidth, height: scaledHeight)
//        var scaleFactor: CGFloat
        
//        if image.size.width > image.size.height {
//            scaleFactor = image.size.height / image.size.width
//            scaledSize.width = scaledWidth
//            scaledSize.height = scaledSize.width * scaleFactor
//        } else {
//            scaleFactor = image.size.width / image.size.height
//            scaledSize.height = scaledHeight
//            scaledSize.width = scaledSize.height * scaleFactor
//        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
