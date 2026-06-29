//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol FrameMenuViewDelegate {
    
    @objc optional func frameMenuView_TickButtonTapped()
    @objc optional func frameMenuView_CrossButtonTapped()
    @objc optional func frameMenuView_Appeared()
    func frameMenuView_didSelectStickerName(stickerName:String)
}


class FrameMenuView: UIView {
    
    var delegate:FrameMenuViewDelegate!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .clear
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if (delegate != nil) {
            delegate.frameMenuView_CrossButtonTapped?()
        }
    }
    
    

}
