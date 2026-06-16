//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol OrientationMenuViewDelegate {
    
//    @objc optional func orientationMenuView_TickButtonTapped()
    @objc optional func orientationMenuView_CrossButtonTapped()
    @objc optional func orientationMenuView_Appeared()
    
    @objc optional func orientationMenuView_HFlipButtonAction()
    @objc optional func orientationMenuView_VFlipButtonAction()
    
    @objc optional func orientationMenuView_RotateBackwardButtonAction()
    @objc optional func orientationMenuView_RotateForwardButtonAction()
    
    @objc optional func orientationMenuView_ScaleSliderAction(scaleValue:CGFloat)
    @objc optional func orientationMenuView_RotationSliderAction(rotateValue:CGFloat)
}


class OrientationMenuView: UIView {
    
    var delegate:OrientationMenuViewDelegate!
    
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
            delegate.orientationMenuView_CrossButtonTapped?()
        }
    }
    
    
    @IBAction func hFlipButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.orientationMenuView_HFlipButtonAction?()
        }
    }
    
    @IBAction func vFlipButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.orientationMenuView_VFlipButtonAction?()
        }
    }
    
    @IBAction func rotateBackwardButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.orientationMenuView_RotateBackwardButtonAction?()
        }
    }
    
    @IBAction func rotateForwardButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.orientationMenuView_RotateForwardButtonAction?()
        }
    }
    
    @IBAction func scaleSliderValueChanged(_ sender: UISlider) {
        if (delegate != nil) {
            let scaleValue:CGFloat = CGFloat(sender.value)
            delegate.orientationMenuView_ScaleSliderAction?(scaleValue: scaleValue)
        }
    }
    
    @IBAction func rotationSliderValueChanged(_ sender: UISlider) {
        if (delegate != nil) {
            let rotateValue:CGFloat = CGFloat(sender.value)
            delegate.orientationMenuView_RotationSliderAction?(rotateValue: rotateValue)
        }
    }
    
}
