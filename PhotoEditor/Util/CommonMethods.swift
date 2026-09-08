//
//  CommonMethods.swift
//  StickerView
//
//  Created by Rashed Nizam on 17/3/21.
//

import UIKit

class CommonMethods: NSObject {

    static let ins = CommonMethods()
    
    func uiImageWithName(named: String) -> UIImage{
        var image = UIImage(contentsOfFile: Bundle.main.path(forResource: named, ofType: "png")!)
        if image == nil {
            image = UIImage(contentsOfFile: Bundle.main.path(forResource: named, ofType: "jpg")!)
        }
        return image ?? UIImage(named: named)!
    }
    
    func renderImage(fromLayer layer: CALayer?, withRect rect: CGRect, andScale scale: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(layer?.bounds.size ?? CGSize.zero, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            layer?.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func drawImage(fromView view: UIView?, withRect rect: CGRect) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        view?.drawHierarchy(in: view?.bounds ?? CGRect.zero, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
