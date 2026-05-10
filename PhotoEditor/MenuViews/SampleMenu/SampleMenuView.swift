//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol SampleMenuViewDelegate {
    
    @objc optional func sampleMenuView_TickButtonTapped()
    @objc optional func sampleMenuView_CrossButtonTapped()
    @objc optional func sampleMenuView_Appeared()
    @objc optional func sampleMenuView_ItemSelectedAt() -> Int;
}


class SampleMenuView: UIView {
    
    var delegate:SampleMenuViewDelegate!
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
            delegate.sampleMenuView_CrossButtonTapped?()
        }
    }
    
    

}
