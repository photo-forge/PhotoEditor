//
//  BGCategoryView.swift
//  BGView
//
//  Created by Rashed Nizam on 28/2/21.
//

import UIKit

public protocol BGCategoryViewDelegate {
    func bgCategoryView_didSelectAt(bgCategoryName:String)
}

class BGCategoryView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:BGCategoryViewDelegate!
    
    var collectionView: UICollectionView!
    
    var categoryNames: [String] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        // Populate category array from plist
        var bgInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "BGImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            bgInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        let categoryImages = bgInfoDic?["Categories"] as? [AnyHashable]
        for category in categoryImages ?? [] {
            categoryNames.append(category as! String)
        }
        
        // draw bottom line
        let lineView = UIView(frame: CGRect(x: 0, y: self.bounds.height-1, width: self.bounds.width, height: 1));
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor(red: 40/255.0, green: 60/255.0, blue: 80/255.0, alpha: 1.0)
        
        // Collection View
        let cvFrame = CGRect(x: self.bounds.width*0.1, y: 0, width: self.bounds.width-self.bounds.width*0.2, height: self.bounds.height)
        
        let inset:CGFloat = 8.0
        let cellSize:CGFloat = cvFrame.height - inset
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumInteritemSpacing = inset * 4
        layout.minimumLineSpacing = inset * 4
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BGMenuCategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
//        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! BGMenuCategoryCell
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: categoryNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            delegate.bgCategoryView_didSelectAt(bgCategoryName:categoryNames[indexPath.row])
        }
    }
    
}

class BGMenuCategoryCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var selectedBar:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // Image
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-6))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        // Bar
        selectedBar = UIView(frame: CGRect(x: 0, y: self.bounds.height-2, width: self.bounds.width, height: 2))
        selectedBar.backgroundColor = UIColor(red: 120/255.0, green: 180/255.0, blue: 240/255.0, alpha: 1.0)
        selectedBar.layer.cornerRadius = 1;
        self.addSubview(selectedBar)
        selectedBar.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                selectedBar.isHidden = false
            } else {
                selectedBar.isHidden = true
            }
        }
    }
    
    
    
    
}
