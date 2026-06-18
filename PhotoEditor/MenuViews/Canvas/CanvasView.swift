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
    @objc optional func canvasView_ItemSelectedWithSize(size:CGSize)
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

class CanvasView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var delegate:CanvasViewDelegate!
    
    @IBOutlet weak var viewContainer: UIView!
    var collectionView: UICollectionView!
    
    let menuItems = [CanvasType.RarioOriginal, .RarioSquare, .Rario9x16, .Rario16x9, .Rario3x4, .Rario4x3, .Rario2x3, .Rario3x2, .Rario1x3, .Rario3x1, .Rario1x2, .Rario2x1]
    let menuItemNames = ["RarioOriginal", "RarioSquare", "Rario9x16", "Rario16x9", "Rario3x4", "Rario4x3", "Rario2x3", "Rario3x2", "Rario1x3", "Rario3x1", "Rario1x2", "Rario2x1"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.commonInit()
        }
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
            layout.estimatedItemSize = .zero
        } else {
            layout.sectionInset = UIEdgeInsets(top: inset, left: inset*3, bottom: inset, right: inset)
            layout.minimumInteritemSpacing = inset * 4
            layout.minimumLineSpacing = inset * 4
            layout.estimatedItemSize = .zero
        }
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CanvasMenuCell.self, forCellWithReuseIdentifier: "CanvasMenuCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset:CGFloat = 2.0
        let cellHeight:CGFloat = collectionView.bounds.height - inset*2
        
        let image = UIImage(named: menuItemNames[indexPath.row])
        let imageSize:CGSize = image?.size ?? CGSize.zero
        let cellWidth:CGFloat = cellHeight * imageSize.width / imageSize.height
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        }
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CanvasMenuCell", for: indexPath) as! CanvasMenuCell
        cell.imageView.image = UIImage(named: menuItemNames[indexPath.row])
        cell.imageView.frame = cell.bounds
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            switch menuItems[indexPath.row] {
            case .RarioOriginal:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1024, height: 1024))
            case .RarioSquare:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1024, height: 1024))
            case .Rario9x16:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 900, height: 1600))
            case .Rario16x9:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1600, height: 900))
            case .Rario3x4:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 900, height: 1200))
            case .Rario4x3:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1200, height: 900))
            case .Rario2x3:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1000, height: 1500))
            case .Rario3x2:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1500, height: 1000))
            case .Rario1x3:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 600, height: 1800))
            case .Rario3x1:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1800, height: 600))
            case .Rario1x2:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 800, height: 1600))
            case .Rario2x1:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1600, height: 800))
            default:
                delegate.canvasView_ItemSelectedWithSize?(size: CGSize(width: 1000, height: 1000))
            }
                        
        }
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
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
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
