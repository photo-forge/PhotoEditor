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
    
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint! //  0
    @IBOutlet weak var menuContainerTopConstraint: NSLayoutConstraint!  // 34
    @IBOutlet weak var containerViewBottomConstraints: NSLayoutConstraint!  // 78
    
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
        
        self.dismiss(animated: true) {
            print("View Dismissed")
        }
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
    }
    func bottomMenuBar_BGGalleryButtonTapped() {
        print("BG")
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
    
    func hideBottomMenuBar(completion: (() -> Void)? = nil) {
        bottomBarConstraint.constant = -78
        containerViewBottomConstraints.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = false
            completion?()
        }
    }
    
    func showBottomMenuBar(completion: (() -> Void)? = nil) {
        bottomBarConstraint.constant = 0
        containerViewBottomConstraints.constant = 78
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = true
            completion?()
        }
    }
    
    func showMenuView(view: UIView, height: CGFloat) {
        
                
        hideBottomMenuBar { [self] in
            menuContainerView.addSubview(view)
            
            menuContainerTopConstraint.constant = -height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            } completion: { [self] _ in
                menuContainerView.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideMenuView(view:UIView, completion: (() -> Void)? = nil) {
        menuContainerTopConstraint.constant = 34
        containerViewBottomConstraints.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            menuContainerView.isUserInteractionEnabled = false
            view.removeFromSuperview()
            showBottomMenuBar {
            }
            completion?()
        }
        
    }
    
    
    // MARK: Canvas View and Delegates
    
    func createCanvasView() {
        
        // Create View
        let viewHeight: CGFloat = 150
        let viewFrame: CGRect = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: viewHeight)
        if canvasView == nil {
            canvasView = Bundle.main.loadNibNamed("CanvasView", owner: nil, options: nil)?.first as? CanvasView
            canvasView?.delegate = self
        }
        canvasView?.frame = viewFrame
        
        // Show Menu View
        showMenuView(view: canvasView!, height: viewHeight)
    }
    
    func canvasView_CrossButtonTapped() {
        print("canvasView_CrossButtonTapped")
        hideMenuView(view: canvasView!) {
        }
    }
    
}
 
