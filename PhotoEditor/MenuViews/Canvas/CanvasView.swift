//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/22/26.
//

import UIKit

@objc protocol CanvasViewDelegate {
    
    @objc optional func canvasView_TickButtonTapped()
    @objc optional func canvasView_CrossButtonTapped()
    @objc optional func canvasView_freeSizeButtonTapped()
    @objc optional func canvasView_Appeared()
    @objc optional func canvasView_ItemSelectedAt() -> Int;
}

enum CanvasType: Int {
    case RarioOriginal = 0
    case RarioSquare
    case Rario9x16
    case Rario16x9
    case Rario3x4
    case Rario4x3
    case Rario2x3
    case Rario3x2
    case Rario1x3
    case Rario3x1
    case Rario1x2
    case Rario2x1
}

class CanvasView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var delegate:CanvasViewDelegate!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let menuItems = [CanvasType.RarioOriginal, .RarioSquare, .Rario9x16, .Rario16x9, .Rario3x4, .Rario4x3, .Rario2x3, .Rario3x2, .Rario1x3, .Rario3x1, .Rario1x2, .Rario2x1]
    let menuItemNames = ["RarioOriginal", "RarioSquare", "Rario9x16", "Rario16x9", "Rario3x4", "Rario4x3", "Rario2x3", "Rario3x2", "Rario1x3", "Rario3x1", "Rario1x2", "Rario2x1"]
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if (delegate != nil) {
            delegate.canvasView_CrossButtonTapped?()
        }
    }
    

    private func commonInit() {
        self.backgroundColor = .clear
        
        // Collection View
        let cvFrame = CGRect(x: 0, y: 44, width: self.frame.width, height: self.frame.height - 44)
        
        let inset:CGFloat = 2.0
        let cellSize:CGFloat = cvFrame.height - inset*2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        if menuItems.count <= 7 {
            layout.sectionInset = UIEdgeInsets(top: inset*2, left: inset*6, bottom: inset, right: inset*6)
            //            layout.minimumInteritemSpacing = inset * 2
            let numOfItems: CGFloat = CGFloat(menuItems.count)
            let lineSpacing: CGFloat = (cvFrame.width - (layout.sectionInset.left+layout.sectionInset.right) - cellSize*numOfItems-2) / (numOfItems-1)
            layout.minimumLineSpacing = lineSpacing
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
        } else {
            layout.sectionInset = UIEdgeInsets(top: inset, left: inset*3, bottom: inset, right: inset)
            layout.minimumInteritemSpacing = inset * 4
            layout.minimumLineSpacing = inset * 4
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
        }
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CanvasMenuCell.self, forCellWithReuseIdentifier: "MenuItemCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! BottomMenuBarCell
        cell.imageView.image = UIImage(named: menuItemNames[indexPath.row])!
        return cell
    }
    

}

class CanvasMenuCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        // Image
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-6))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
    }
    
    override var isSelected: Bool {
        didSet {
            //            if self.isSelected {
            //                selectedBar.isHidden = false
            //            } else {
            //                selectedBar.isHidden = true
            //            }
        }
    }
    
}
