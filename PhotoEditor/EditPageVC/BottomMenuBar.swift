//
//  BottomMenuBar.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/18/26.
//

import UIKit

@objc protocol PEHomeMenuBarDelegate {
    
    @objc optional func bottomMenuBar_FGGalleryButtonTapped()
    @objc optional func bottomMenuBar_BGGalleryButtonTapped()
    @objc optional func bottomMenuBar_CanvasButtonTapped()
    @objc optional func bottomMenuBar_FilterButtonTapped()
    @objc optional func bottomMenuBar_OverlayButtonTapped()
    @objc optional func bottomMenuBar_StickerButtonTapped()
    @objc optional func bottomMenuBar_TextButtonTapped()
    @objc optional func bottomMenuBar_DoodleButtonTapped()
}

class BottomMenuBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
