//
//  BGMenuView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit
import SwiftUI

@objc protocol BGMenuViewDelegate {
    @objc optional func bgMenuView_TickButtonTapped()
    @objc optional func bgMenuView_CrossButtonTapped()
    @objc optional func bgMenuView_Appeared()
    @objc optional func bgMenuView_didSelectBGName(bgName:String)
    @objc optional func bgMenuView_didSelectBGColor(bgColor:UIColor)
}


class BGMenuView: UIView, BGCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:BGMenuViewDelegate!
    
    @IBOutlet var categoryViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    var collectionView: UICollectionView!
    
    var bgNamesDic: NSDictionary?
    var bgNames: NSMutableArray!
    var bgCategory: String!
    
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
        
//        printColorCodes()
    }
    
    func populateBGInfo() {
        
        // Populate category array from plist
        var bgInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "BGImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            bgInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        bgCategory = "bgColor"
        bgNamesDic = bgInfoDic?["BGItems"] as? NSDictionary
        bgNames = bgNamesDic?[bgCategory ?? "bgColor"] as? NSMutableArray
        print(bgNames.count)
    }
    
    @objc func createInterface() {
        
        // Main Categories
        let bgCategoryView = BGCategoryView(frame: categoryViewContainer.bounds)
        categoryViewContainer.addSubview(bgCategoryView)
        bgCategoryView.delegate = self
        
        // Collection View
        let cvFrame = collectionViewContainer.bounds
        let layout: UICollectionViewFlowLayout = cvLayout(inset: 4.0, cvFrame: cvFrame, numberOfCells: 4)
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionViewContainer.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickerMenuStickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func cvLayout(inset:CGFloat, cvFrame:CGRect, numberOfCells:NSInteger) -> UICollectionViewFlowLayout {
        let cellSize:CGFloat = (cvFrame.height - inset*(CGFloat(numberOfCells)+2)-1)/CGFloat(numberOfCells)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset*1.5, left: inset*1.5, bottom: inset, right: inset*1.5)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if (delegate != nil) {
            delegate.bgMenuView_CrossButtonTapped?()
        }
    }
    
    func bgCategoryView_didSelectAt(bgCategoryName: String) {
        print(bgCategoryName)
        
        bgNames = NSMutableArray()
        bgNames.add("GradientImage0")
        print("count: " + bgNames.count.description)
        bgCategory = "bgGradient"
        collectionView.reloadData()
        
        bgCategory = bgCategoryName
        bgNames = bgNamesDic?[bgCategoryName] as? NSMutableArray
        
        if bgCategoryName == "bgColor" {
            let layout: UICollectionViewFlowLayout = cvLayout(inset: 4.0, cvFrame: collectionViewContainer.bounds, numberOfCells: 4)
            collectionView.setCollectionViewLayout(layout, animated: false)
        } else {
            let layout: UICollectionViewFlowLayout = cvLayout(inset: 8.0, cvFrame: collectionViewContainer.bounds, numberOfCells: 2)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
        collectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bgNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        cell.backgroundColor = .lightGray
        cell.imageView.frame = cell.bounds
        let name = bgNames?[indexPath.row] as! String
        if bgCategory == "bgColor" {
            let color = UIColor(hex: name)
            cell.backgroundColor = color
        } else {
//            let image = UIImage(named: String.init(format: "%@-thumb", name))
            cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@-thumb", name))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            
            if bgCategory == "bgColor" {
                let name = bgNames?[indexPath.row] as! String
                delegate.bgMenuView_didSelectBGColor?(bgColor:UIColor(hex: name))
            } else {
                let name = bgNames?[indexPath.row] as! String
                delegate.bgMenuView_didSelectBGName?(bgName: name)
            }
            
        }
    }
    
    
    
    func printColorCodes() {
        var count:Int = 0
        for i in 0..<6 {
            for j in 0..<5 {
                for k in 0..<4 {
                    
                    var oneStr:String!
                    var twoStr:String!
                    var threeStr:String!
                    
                    switch i {
                    case 0:
                        oneStr = "ff"
                    case 1:
                        oneStr = "cc"
                    case 2:
                        oneStr = "99"
                    case 3:
                        oneStr = "66"
                    case 4:
                        oneStr = "33"
                    case 5:
                        oneStr = "00"
                    default:
                        oneStr = "00"
                    }
                    
                    switch j {
                    case 0:
                        twoStr = "00"
                    case 1:
                        twoStr = "3f"
                    case 2:
                        twoStr = "7f"
                    case 3:
                        twoStr = "bf"
                    case 4:
                        twoStr = "ff"
                    default:
                        twoStr = "00"
                    }
                    
                    switch k {
                    case 0:
                        threeStr = "00"
                    case 1:
                        threeStr = "54"
                    case 2:
                        threeStr = "a7"
                    case 3:
                        threeStr = "ff"
                    default:
                        threeStr = "00"
                    }
                    
                    count += 1
                    print(String(count)+": " + oneStr + twoStr + threeStr)
                }
            }
        }
    }

}
