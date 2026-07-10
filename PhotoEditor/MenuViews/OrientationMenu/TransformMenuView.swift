//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol TransformMenuViewDelegate {
    
//    @objc optional func transformMenuView_TickButtonTapped()
    @objc optional func transformMenuView_CrossButtonTapped()
    @objc optional func transformMenuView_Appeared()
    
    @objc optional func transformMenuView_HFlipButtonAction()
    @objc optional func transformMenuView_VFlipButtonAction()
    
    @objc optional func transformMenuView_RotateBackwardButtonAction()
    @objc optional func transformMenuView_RotateForwardButtonAction()
    
    @objc optional func transformMenuView_ScaleSliderAction(scaleValue:CGFloat)
    @objc optional func transformMenuView_RotationSliderAction(rotateValue:CGFloat)
}


class TransformMenuView: UIView {
    
    var delegate:TransformMenuViewDelegate!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.commonInit()
        }
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
            delegate.transformMenuView_CrossButtonTapped?()
        }
    }
    
    
    @IBAction func hFlipButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.transformMenuView_HFlipButtonAction?()
        }
    }
    
    @IBAction func vFlipButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.transformMenuView_VFlipButtonAction?()
        }
    }
    
    @IBAction func rotateBackwardButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.transformMenuView_RotateBackwardButtonAction?()
        }
    }
    
    @IBAction func rotateForwardButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.transformMenuView_RotateForwardButtonAction?()
        }
    }
    
    @IBAction func scaleSliderValueChanged(_ sender: UISlider) {
        if (delegate != nil) {
            let scaleValue:CGFloat = CGFloat(sender.value)
            delegate.transformMenuView_ScaleSliderAction?(scaleValue: scaleValue)
        }
    }
    
    @IBAction func rotationSliderValueChanged(_ sender: UISlider) {
        if (delegate != nil) {
            var rotateValue:CGFloat = CGFloat(sender.value)
            
            let threshold:CGFloat = 0.001
            if (rotateValue > 0.0-threshold && rotateValue < 0.0+threshold) {
                rotateValue = 0.0
            }
            if (rotateValue > 0.25-threshold && rotateValue < 0.25+threshold) {
                rotateValue = 0.25
            }
            if (rotateValue > 0.50-threshold && rotateValue < 0.50+threshold) {
                rotateValue = 0.50
            }
            if (rotateValue > 0.75-threshold && rotateValue < 0.75+threshold) {
                rotateValue = 0.75
            }
            if (rotateValue > 1.0-threshold && rotateValue < 1.0+threshold) {
                rotateValue = 1.0
            }
            
            
            delegate.transformMenuView_RotationSliderAction?(rotateValue: rotateValue)
        }
    }
    
}
