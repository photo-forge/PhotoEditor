//
//  BGMenuView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol BGMenuViewDelegate {
    @objc optional func bgMenuView_TickButtonTapped()
    @objc optional func bgMenuView_CrossButtonTapped()
    @objc optional func bgMenuView_Appeared()
    @objc optional func bgMenuView_didSelectBGName(bgName:String)
}


class BGMenuView: UIView, BGCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:BGMenuViewDelegate!
    
    @IBOutlet var categoryViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    var collectionView: UICollectionView!
    
    var bgNamesDic: NSDictionary?
    var bgNames: NSArray!
    
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
        
        populateBGInfo()
        perform(#selector(self.createInterface), with: nil, afterDelay: 0.1)
//        createInterface()
    }
    
    func populateBGInfo() {
        
        // Populate category array from plist
        var bgInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "BGImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            bgInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        bgNamesDic = bgInfoDic?["BGItems"] as? NSDictionary
        bgNames = bgNamesDic?["bgColor"] as? NSArray
        print(bgNames.count)
    }
    
    @objc func createInterface() {
        
        // Main Categories
        let bgCategoryView = BGCategoryView(frame: categoryViewContainer.bounds)
        categoryViewContainer.addSubview(bgCategoryView)
        bgCategoryView.delegate = self
        
        
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
            delegate.bgMenuView_CrossButtonTapped?()
        }
    }
    
    func bgCategoryView_didSelectAt(bgCategoryName: String) {
        print(bgCategoryName)
        
        bgNames = bgNamesDic?[bgCategoryName] as? NSArray
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bgNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        cell.backgroundColor = .lightGray
        let name = bgNames?[indexPath.row] as! String
        let image = UIImage(named: String.init(format: "%@-thumb", name))
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@-thumb", name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            let name = bgNames?[indexPath.row] as! String
            delegate.bgMenuView_didSelectBGName?(bgName: name)
        }
    }

}
