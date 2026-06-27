//
//  EditPageVC.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/18/26.
//

import UIKit

class EditPageVC: UIViewController, UIGestureRecognizerDelegate, BottomMenuBarDelegate, SampleMenuViewDelegate, CanvasViewDelegate, OrientationMenuViewDelegate, StickerMenuViewDelegate, ImageStickerViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomMenuBar: BottomMenuBar!
    @IBOutlet weak var menuContainerView: UIView!
    
    @IBOutlet weak var topBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint! //  0
    @IBOutlet weak var menuContainerTopConstraint: NSLayoutConstraint!  // 34
    @IBOutlet weak var containerViewBottomConstraints: NSLayoutConstraint!  // 78
    
    @IBOutlet weak var editViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var editViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var frameImageView: UIImageView!
    
    var screenBound : CGRect!
    
    var mainImage: UIImage!
    var canvasSize: CGSize = CGSize(width: 1024, height: 1920)
    
    // Menus
    var sampleMenuView: SampleMenuView!
    var canvasMenuView: CanvasView!
    var orientationMenuView: OrientationMenuView!
    
    var stickerMenuView : StickerMenuView? = nil
    var stickerArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenBound = UIScreen.main.bounds
        
        // BottomBar
        bottomMenuBar.delegate = self
        
        // BG View
        bgView.contentMode = .scaleAspectFill
        bgView.backgroundColor = .green
        bgView.isUserInteractionEnabled = true
        
        // Image View
//        imageView.contentMode = .scaleAspectFit
        imageView.image = mainImage
//        imageView.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
                        
            updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.0)
        }
        
    }
        
    // MARK: TopBarDelegate
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        print("Show Share View")
        
    }
    
    // MARK: BottomMenuBarDelegate
    
    func bottomMenuBar_FGGalleryButtonTapped() {
        print("Gallery")
        createSampleMenuView()
    }
    func bottomMenuBar_BGGalleryButtonTapped() {
        print("BG")
    }
    func bottomMenuBar_CanvasButtonTapped() {
        print("Canvas - Appear")
        appearCanvasView()
    }
    func bottomMenuBar_FilterButtonTapped() {
        print("Filter")
    }
    func bottomMenuBar_OverlayButtonTapped() {
        print("Overlay")
        appearOrientationMenuView()
    }
    func bottomMenuBar_StickerButtonTapped() {
        print("Sticker")
        appearStickerMenuView()
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
        UIView.animate(withDuration: 0.2) { [self] in
            self.view.layoutIfNeeded()
            updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.15)
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = false
            completion?()
        }
    }
    
    func showBottomMenuBar(completion: (() -> Void)? = nil) {
        bottomBarConstraint.constant = 0
        containerViewBottomConstraints.constant = 78
        UIView.animate(withDuration: 0.2) { [self] in
            self.view.layoutIfNeeded()
            updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.15)
        } completion: { [self] _ in
            bottomMenuBar.isUserInteractionEnabled = true
            completion?()
        }
    }
    
    func showMenuView(view: UIView, height: CGFloat) {
        
        // Hide Bottom Bar
        hideBottomMenuBar { [self] in
            // Add Menu View
            menuContainerView.addSubview(view)
            
            // Appear Menu
            topBarTopConstraint.constant = 0
            menuContainerTopConstraint.constant = -height
            UIView.animate(withDuration: 0.3) { [self] in
                self.view.layoutIfNeeded()
                updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.2)
            } completion: { [self] _ in
                menuContainerView.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideMenuView(view:UIView, completion: (() -> Void)? = nil) {
        topBarTopConstraint.constant = 44
        menuContainerTopConstraint.constant = 34
        containerViewBottomConstraints.constant = 0
        UIView.animate(withDuration: 0.3) { [self] in
            self.view.layoutIfNeeded()
            updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.2)
        } completion: { [self] _ in
            menuContainerView.isUserInteractionEnabled = false
            view.removeFromSuperview()
            showBottomMenuBar {
            }
            completion?()
        }
        
    }
    
    
    // MARK: Sample Menu View and Delegates
    
    func createSampleMenuView() {
        
        // Create View
        let viewHeight: CGFloat = 200
        let viewFrame: CGRect = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: viewHeight)
        if sampleMenuView == nil {
            sampleMenuView = Bundle.main.loadNibNamed("SampleMenuView", owner: nil, options: nil)?.first as? SampleMenuView
            sampleMenuView?.delegate = self
        }
        sampleMenuView?.frame = viewFrame
        sampleMenuView.layoutIfNeeded()
        
        // Show Menu View
        showMenuView(view: sampleMenuView!, height: viewHeight)
    }
    
    func sampleMenuView_CrossButtonTapped() {
        print("sampleMenuView_CrossButtonTapped")
        hideMenuView(view: sampleMenuView!) {
        }
    }
    
    
    // MARK: Canvas View and Delegates
    
    func appearCanvasView() {
        
        // Create View
        let viewHeight: CGFloat = 150
        let viewFrame: CGRect = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: viewHeight)
        if canvasMenuView == nil {
            canvasMenuView = Bundle.main.loadNibNamed("CanvasView", owner: nil, options: nil)?.first as? CanvasView
            canvasMenuView?.delegate = self
        }
        canvasMenuView?.frame = viewFrame
        canvasMenuView.layoutIfNeeded()
        
        // Show Menu View
        showMenuView(view: canvasMenuView!, height: viewHeight)
    }
    
    func canvasView_CrossButtonTapped() {
        print("canvasView_CrossButtonTapped")
        hideMenuView(view: canvasMenuView!) {
            print("edit view size: ", self.editView.bounds.size)
        }
    }
    
    var timer : Timer?
    var timerCount: Int = 0
    var loopCount: Int = 0
    var widthPerLoopCollageView: CGFloat!
    var heightPerLoopCollageView: CGFloat!
    var previousCanvasSize: CGSize!
    
    func canvasView_ItemSelectedWithSize(size: CGSize) {
        print("Canvas", size.width, size.height)
        
        loopCount = 30
        
        let widthDiff: CGFloat = size.width - canvasSize.width
        let heightDiff: CGFloat = size.height - canvasSize.height
        widthPerLoopCollageView = widthDiff / CGFloat(loopCount)
        heightPerLoopCollageView = heightDiff / CGFloat(loopCount)
        
        previousCanvasSize = canvasSize
        canvasSize = size
        
        timerCount = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateEditView), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateEditView() {
        
        previousCanvasSize.width += widthPerLoopCollageView;
        previousCanvasSize.height += heightPerLoopCollageView;
        updateEditViewFrameWithCanvas(size: previousCanvasSize, duration: 0.0)
        
        timerCount += 1
        if timer!.isValid && timerCount >= loopCount {
            timer?.invalidate()
            timer = nil
            updateEditViewFrameWithCanvas(size: canvasSize, duration: 0.0)
        }
        
    }
    
    func updateEditViewFrameWithCanvas(size:CGSize, duration:TimeInterval) {
        
//        print("Canvas .....", size.width, size.height)
        
        editViewWidthConstraint.constant = size.width
        editViewHeightConstraint.constant = size.height
        let scale = scaleValueOfEditView(size: size)
        editView.transform = CGAffineTransform(scaleX: scale, y: scale)
        if duration > 0 {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    func scaleValueOfEditView(size:CGSize) -> CGFloat {
        
        let containerHWRatio: CGFloat = containerView.bounds.width / containerView.bounds.height
        let sizeHWRatio: CGFloat = size.width / size.height
        
        if containerHWRatio < sizeHWRatio {
            return containerView.bounds.width / size.width
        } else {
            return containerView.bounds.height / size.height
        }
        
//        let scaleX: CGFloat = containerView.bounds.width / size.width
//        let scaleY: CGFloat = containerView.bounds.height / size.height
//        print("Scale .....", scaleX, scaleY)
//        return min(scaleX, scaleY)
    }
    
    
    // MARK: Orientation Menu View and Delegates
    
    func appearOrientationMenuView() {
        
        // Create View
        let viewHeight: CGFloat = 200
        let viewFrame: CGRect = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: viewHeight)
        if orientationMenuView == nil {
            orientationMenuView = Bundle.main.loadNibNamed("OrientationMenuView", owner: nil, options: nil)?.first as? OrientationMenuView
            orientationMenuView?.delegate = self
        }
        orientationMenuView?.frame = viewFrame
        orientationMenuView.layoutIfNeeded()
        
        // Show Menu View
        showMenuView(view: orientationMenuView!, height: viewHeight)
    }
    
    func orientationMenuView_Appeared() {
        
    }
    
    func orientationMenuView_CrossButtonTapped() {
        print("OrientationMenuView_CrossButtonTapped")
        hideMenuView(view: orientationMenuView!) {
        }
    }
    
    var scaleValueOfImageView: CGFloat = 1
    var isHFlipped = false
    func orientationMenuView_HFlipButtonAction() {
        print("HFlip")
        isHFlipped.toggle()
        if isHFlipped {
            print("HFlip ON")
            imageView.transform = CGAffineTransform(scaleX: -scaleValueOfImageView, y: scaleValueOfImageView)
        } else {
            print("HFlip OFF")
            imageView.transform = CGAffineTransform(scaleX: scaleValueOfImageView, y: scaleValueOfImageView)
        }
        
    }
    
    var isVFlipped = false
    func orientationMenuView_VFlipButtonAction() {
        print("VFlip")
        isVFlipped.toggle()
        if isVFlipped {
            print("VFlip ON")
            imageView.transform = CGAffineTransform(scaleX: scaleValueOfImageView, y: -scaleValueOfImageView)
        } else {
            print("VFlip OFF")
            imageView.transform = CGAffineTransform(scaleX: scaleValueOfImageView, y: scaleValueOfImageView)
        }
    }
    
//    var rotationValue: CGFloat = 0
    var rotateDegree: CGFloat = 0
    var rotationDegree: CGFloat = 0
    func orientationMenuView_RotateForwardButtonAction() {
        rotationDegree += 90;
        let tiltedImage = mainImage?.rotated(byDegrees: rotateDegree + rotationDegree)
        imageView.image = tiltedImage
        
//        rotationValue += .pi / 2
//        imageView.transform = CGAffineTransform(rotationAngle: rotationValue)
    }
    
    func orientationMenuView_RotateBackwardButtonAction() {
        print("RotateBackward")
        rotationDegree -= 90;
        let tiltedImage = mainImage?.rotated(byDegrees: rotateDegree + rotationDegree)
        imageView.image = tiltedImage
        
//        rotationValue -= .pi / 2
//        imageView.transform = CGAffineTransform(rotationAngle: rotationValue)
    }
    
    func orientationMenuView_ScaleSliderAction(scaleValue: CGFloat) {
        print("ScaleValue: \(scaleValue)")
        scaleValueOfImageView = 1 + (scaleValue-0.15)*4
        imageView.transform = CGAffineTransform(scaleX: scaleValueOfImageView, y: scaleValueOfImageView)
    }
    
    func orientationMenuView_RotationSliderAction(rotateValue: CGFloat) {
        print("RotateValue: \(rotateValue)")
        rotateDegree  = (rotateValue - 0.5)*360
        let tiltedImage = mainImage?.rotated(byDegrees: rotateDegree + rotationDegree)
        imageView.image = tiltedImage
    }
    
    // MARK: Sticker View and Delegates
    
    func appearStickerMenuView() {
        
        if stickerMenuView == nil {
            let viewHeight: CGFloat = 300
            let viewFrame: CGRect = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: viewHeight)
            stickerMenuView = StickerMenuView(frame: viewFrame)
//            view.addSubview(stickerMenuView!)
//            stickerMenuView!.isUserInteractionEnabled = true
            stickerMenuView!.delegate = self;
            
            // Tap Gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            tapGesture.delegate = self
            bgView.addGestureRecognizer(tapGesture)
        }
        
        // Show Menu View
        showMenuView(view: stickerMenuView!, height: stickerMenuView!.bounds.height)
    }
    
    func stickerMenuView_BackButtonTapped() {
        print("Back Button")
        hideMenuView(view: stickerMenuView!) {
        }
    }
    
    func stickerMenuView_TickButtonTapped() {
        print("Tick Button")
        
    }
    
    func stickerMenuView_didSelectStickerName(stickerName: String) {
        
        let image: UIImage = CommonMethods.ins.uiImageWithName(named: stickerName)
        
        // Image Sticker
        let imageSticker = ImageStickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), image: image)
        editView.addSubview(imageSticker);
        imageSticker.center = CGPoint(x: editView.bounds.midX, y: editView.bounds.midY)
        imageSticker.delegate = self
        imageSticker.select()
        stickerArray.add(imageSticker)
        print("StickerCount: \(stickerArray.count)")
    }
    
    
    // MARK: ImageStickerViewDelegate
    
    func imageStickerView_WillBeSelected() {
        deselectAllStickers( )
    }
    func imageStickerView_Selected() {
        
    }
    
    func imageStickerView_WillBeDeselected() {
        
    }
    func imageStickerView_Deselected() {
        
    }
    func imageStickerView_Deleted(sticker: ImageStickerView) {
        stickerArray.remove(sticker)
        print("StickerCount: \(stickerArray.count)")
    }
    
    
    // Tap
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        deselectAllStickers()
    }
    
    func deselectAllStickers() {
        for sticker in stickerArray as! [ImageStickerView] {
            sticker.deselect()
        }
    }
    
    
    
}
 
