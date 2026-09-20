//
//  FilterView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol FilterMenuViewDelegate {
    
    @objc optional func filterMenuView_TickButtonTapped()
    @objc optional func filterMenuView_CrossButtonTapped()
    @objc optional func filterMenuView_Appeared()
    func filterMenuView_didSelectFilterName(filterName:String)
}


class FilterMenuView: UIView, FilterCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:FilterMenuViewDelegate!
    
    @IBOutlet var categoryViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    var collectionView: UICollectionView!
    
    var filterNamesDic: NSDictionary?
    var filterNames: NSArray! = NSArray()
    
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
        
        populateFilterInfo()
        perform(#selector(self.createInterface), with: nil, afterDelay: 0.1)
//        createInterface()
    }
    
    func populateFilterInfo() {
        
        // Populate category array from plist
        var filterInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "FilterInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            filterInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        filterNamesDic = filterInfoDic?["FilterItems"] as? NSDictionary
        filterNames = filterNamesDic?["frame-category-wood"] as? NSArray
        print(filterNames?.count ?? 0)
    }
    
    @objc func createInterface() {
        
        // Main Categories
        let filterCategoryView = FilterCategoryView(frame: categoryViewContainer.bounds)
        categoryViewContainer.addSubview(filterCategoryView)
        filterCategoryView.delegate = self
        
        
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
            delegate.filterMenuView_CrossButtonTapped?()
        }
    }
    
    func filterCategoryView_didSelectAt(filterCategoryName: String) {
        print(filterCategoryName)
        
        filterNames = filterNamesDic?[filterCategoryName] as? NSArray
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        cell.backgroundColor = .lightGray
        let name = filterNames?[indexPath.item] as! String
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@-thumb", name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            let name = filterNames?[indexPath.row] as! String
            delegate.filterMenuView_didSelectFilterName(filterName: name)
        }
    }

}
