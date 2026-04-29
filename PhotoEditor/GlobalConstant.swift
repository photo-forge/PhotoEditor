//
//  GlobalConstant.swift
//  Cut and Paste Photo
//
//  Created by Odyssey Apps on 12/9/16.
//  Copyright © 2016 Odyssey Apps. All rights reserved.
//

import UIKit

enum iDevice {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iPadPro13Inch
}

class GlobalConstant: NSObject {
    
    static let ins = GlobalConstant()
    
    var sSize : CGRect
    var maxLength: CGFloat
    var device = iDevice.iphone4
    var isIPhone = true
    
    var bottomBarHeight: CGFloat {
        return 44
    }
    
    var safeAreaBottom: CGFloat {
        let window = UIApplication.shared.windows.first
        return window!.safeAreaInsets.bottom
    }
    
    override init() {
        
        sSize = UIScreen.main.bounds
        maxLength = max(sSize.width, sSize.height)
                
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            print("iPhone")
            isIPhone = true
            
            if maxLength < 568 {
                device = .iphone4
            }
            else if maxLength == 568 {
                device = .iphone5
            }
            else if maxLength == 667 {
                device = .iphone6
            }
            else if maxLength == 736 {
                device = .iphone6plus
            } else {
                device = .unknown
            }
            
        } else {
            print("iPAD")
            isIPhone = false
            
            if maxLength >= 1366 {
                device = .iPadPro13Inch
            }
        }
                
    }
    
    
}
