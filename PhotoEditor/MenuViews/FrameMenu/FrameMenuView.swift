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
    func frameMenuView_didSelectFrameName(frameName:String)
}


class FrameMenuView: UIView, FrameCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:FrameMenuViewDelegate!
    
    @IBOutlet var categoryViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    var collectionView: UICollectionView!
    
    var frameNamesDic: NSDictionary?
    var frameNames: NSArray!
    
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
        
        populateFrameInfo()
        perform(#selector(self.createInterface), with: nil, afterDelay: 0.1)
//        createInterface()
    }
    
    func populateFrameInfo() {
        
        // Populate category array from plist
        var frameInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "FrameImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            frameInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        frameNamesDic = frameInfoDic?["FrameItems"] as? NSDictionary
        frameNames = frameNamesDic?["frame-category-wood"] as? NSArray
        print(frameNames.count)
    }
    
    @objc func createInterface() {
        
        // Main Categories
        let frameCategoryView = FrameCategoryView(frame: categoryViewContainer.bounds)
        categoryViewContainer.addSubview(frameCategoryView)
        frameCategoryView.delegate = self
        
        
        // Collection View
        let cvFrame = collectionViewContainer.bounds
        
        let inset:CGFloat = 8.0
        let numberOfCells:CGFloat = 1
        let cellSize:CGFloat = (cvFrame.height - inset*(numberOfCells+2)-1)/CGFloat(numberOfCells)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset*1.5, left: inset*1.5, bottom: inset, right: inset*1.5)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionViewContainer.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickerMenuStickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.frameMenuView_CrossButtonTapped?()
        }
    }
    
    func frameCategoryView_didSelectAt(frameCategoryName: String) {
        print(frameCategoryName)
        
        frameNames = frameNamesDic?[frameCategoryName] as? NSArray
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frameNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        cell.backgroundColor = .lightGray
        let name = frameNames?[indexPath.row] as! String
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@-thumb", name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            let name = frameNames?[indexPath.row] as! String
            delegate.frameMenuView_didSelectFrameName(frameName: name)
        }
    }

}
