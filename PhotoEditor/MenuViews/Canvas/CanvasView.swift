//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol CanvasViewDelegate {
    
    @objc optional func canvasView_TickButtonTapped()
    @objc optional func canvasView_CrossButtonTapped()
    @objc optional func canvasView_freeSizeButtonTapped()
    @objc optional func canvasView_Appeared()
    @objc optional func canvasView_ItemSelectedAt() -> Int;
}

enum CanvasType: Int {
    case _Original = 0
    case _Square
    case _NineBySixteen
    case _SixteenByNine
    case _ThreeByFour
    case _FourByThree
    case _OneByThree
    case _ThreeByOne
    case _TwoBythree
    case _ThreeByTwo
    case _OneByTwo
    case _TwoByOne
}

class CanvasView: UIView {
    
    var delegate:CanvasViewDelegate!
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
        self.backgroundColor = .systemBlue
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if (delegate != nil) {
            delegate.canvasView_CrossButtonTapped?()
        }
    }
    
    

}
