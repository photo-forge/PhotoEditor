//
//  EditPageVC.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/18/26.
//

import UIKit

class EditPageVC: UIViewController, BottomMenuBarDelegate, CanvasViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomMenuBar: BottomMenuBar!
    @IBOutlet weak var menuContainerView: UIView!
    
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuContainerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var mainImage: UIImage?
    var canvasView: CanvasView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = mainImage
        
        bottomMenuBar.delegate = self
    }
    
    // MARK: TopBarDelegate
    @IBAction func backButtonAction(_ sender: UIButton) {
        print("Show Discard View")
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        print("Show Share View")
        
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //            completion?()
    //        }
    }
    
    // MARK: BottomMenuBarDelegate
    
    func bottomMenuBar_FGGalleryButtonTapped() {
        print("Gallery")
        
        showMenuView(height: 200)
    }
    func bottomMenuBar_BGGalleryButtonTapped() {
        print("BG")
        
        hideMenuView()
    }
    func bottomMenuBar_CanvasButtonTapped() {
        print("Canvas")
        createCanvasView()
    }
    func bottomMenuBar_FilterButtonTapped() {
        print("Filter")
    }
    func bottomMenuBar_OverlayButtonTapped() {
        print("Overlay")
    }
    func bottomMenuBar_StickerButtonTapped() {
        print("Sticker")
    }
    func bottomMenuBar_TextButtonTapped() {
        print("Text")
    }
    func bottomMenuBar_DoodleButtonTapped() {
        print("Doodle")
    }
    
    // MARK: Animations & Transitions
    
    func showBottomMenuBar(completion: (() -> Void)? = nil) {
        bottomBarConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = true
            completion?()
        }
    }
    
    func hideBottomMenuBar(completion: (() -> Void)? = nil) {
        bottomBarConstraint.constant = -78
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = false
            completion?()
        }
    }
    
    func showMenuView(height: CGFloat) {
        self.menuContainerTopConstraint.constant = -height
        UIView.animate(withDuration: 0.9) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            menuContainerView.isUserInteractionEnabled = true
        }
        
    }
    
    func hideMenuView(completion: (() -> Void)? = nil) {
        menuContainerTopConstraint.constant = -44
        UIView.animate(withDuration: 0.9) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            menuContainerView.isUserInteractionEnabled = false
            completion?()
            showBottomMenuBar {
                
            }
        }
        
    }
    
    
    // MARK: Canvas View and Delegates
    
    func createCanvasView() {
        
        // Create View
        let viewHeight: CGFloat = 200
        let viewFrame: CGRect = CGRect(x: 0, y: 78, width: menuContainerView.frame.width, height: viewHeight)
        if canvasView == nil {
            canvasView = Bundle.main.loadNibNamed("CanvasView", owner: nil, options: nil)?.first as? CanvasView
            canvasView?.frame = viewFrame
            canvasView?.delegate = self
        }
        
        // Show Menu View
        hideBottomMenuBar { [self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                menuContainerView.addSubview(canvasView!)
                self.showMenuView(height: viewHeight)
            }
            
        }
        
    }
    
    func canvasView_CrossButtonTapped() {
        print("canvasView_CrossButtonTapped")
        hideMenuView { [self] in
            canvasView?.removeFromSuperview()
        }
//        if canvasView != nil {
//            canvasView?.removeFromSuperview()
//        }
    }
    
}
 
