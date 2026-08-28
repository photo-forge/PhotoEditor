//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol OverlayMenuViewDelegate {
    
    @objc optional func overlayMenuView_TickButtonTapped()
    @objc optional func overlayMenuView_CrossButtonTapped()
    @objc optional func overlayMenuView_Appeared()
    func overlayMenuView_didSelectOverlayName(overlayName:String)
}


class OverlayMenuView: UIView, OverlayCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:OverlayMenuViewDelegate!
    
    @IBOutlet var categoryViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    var collectionView: UICollectionView!
    
    var overlayNamesDic: NSDictionary?
    var overlayNames: NSArray! = NSArray()
    
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
        
        populateOverlayInfo()
        perform(#selector(self.createInterface), with: nil, afterDelay: 0.1)
//        createInterface()
    }
    
    func populateOverlayInfo() {
        
        // Populate category array from plist
        var overlayInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "OverlayImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            overlayInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        overlayNamesDic = overlayInfoDic?["OverlayItems"] as? NSDictionary
        overlayNames = overlayNamesDic?["frame-category-wood"] as? NSArray
        print(overlayNames.count)
    }
    
    @objc func createInterface() {
        
        // Main Categories
        let overlayCategoryView = OverlayCategoryView(frame: categoryViewContainer.bounds)
        categoryViewContainer.addSubview(overlayCategoryView)
        overlayCategoryView.delegate = self
        
        
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
            delegate.overlayMenuView_CrossButtonTapped?()
        }
    }
    
    func overlayCategoryView_didSelectAt(overlayCategoryName: String) {
        print(overlayCategoryName)
        
        overlayNames = overlayNamesDic?[overlayCategoryName] as? NSArray
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        overlayNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        cell.backgroundColor = .lightGray
        let name = overlayNames?[indexPath.item] as! String
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@-thumb", name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            let name = overlayNames?[indexPath.row] as! String
            delegate.overlayMenuView_didSelectOverlayName(overlayName: name)
        }
    }

}
