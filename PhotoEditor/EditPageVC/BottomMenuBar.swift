//
//  BottomMenuBar.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/18/26.
//

import UIKit

@objc protocol BottomMenuBarDelegate {
    
    @objc optional func bottomMenuBar_FGGalleryButtonTapped()
    @objc optional func bottomMenuBar_BGGalleryButtonTapped()
    @objc optional func bottomMenuBar_CanvasButtonTapped()
    @objc optional func bottomMenuBar_FilterButtonTapped()
    @objc optional func bottomMenuBar_OverlayButtonTapped()
    @objc optional func bottomMenuBar_StickerButtonTapped()
    @objc optional func bottomMenuBar_TextButtonTapped()
    @objc optional func bottomMenuBar_DoodleButtonTapped()
}

enum BottomMenuBarType: Int {
    case _FGGallery = 0
    case _BGGallery
    case _Canvas
    case _Filter
    case _Overlay
    case _Sticker
    case _Text
    case _Doodle
}

class BottomMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:BottomMenuBarDelegate!
    
    var collectionView: UICollectionView!
    
    let menuItems = [BottomMenuBarType._FGGallery, ._BGGallery, ._Canvas, ._Filter, ._Overlay, ._Sticker, ._Text]
    let menuItemNames = ["GalleryButton", "BGButton", "CanvasButton", "FilterButton", "OverlayButton", "StickerButton", "TextButton"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        self.backgroundColor = .green
        
        let barHeight: CGFloat = 44
        
        // Collection View
        let cvFrame = CGRect(x: 0, y: 0, width: frame.width, height: barHeight)
        
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
        collectionView.register(BottomMenuBarCell.self, forCellWithReuseIdentifier: "MenuItemCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! BottomMenuBarCell
        cell.imageView.image = UIImage(named: menuItemNames[indexPath.row])!
//        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: menuItemNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            switch menuItems[indexPath.row] {
            case ._FGGallery:
                delegate.bottomMenuBar_FGGalleryButtonTapped?()
            case ._BGGallery:
                delegate.bottomMenuBar_BGGalleryButtonTapped?()
            case ._Canvas:
                delegate.bottomMenuBar_CanvasButtonTapped?()
            case ._Filter:
                delegate.bottomMenuBar_FilterButtonTapped?()
            case ._Sticker:
                delegate.bottomMenuBar_StickerButtonTapped?()
            case ._Overlay:
                delegate.bottomMenuBar_OverlayButtonTapped?()
            case ._Text:
                delegate.bottomMenuBar_TextButtonTapped?()
            default:
                delegate.bottomMenuBar_FGGalleryButtonTapped?()
            }
            
        }
    }
    
    
}


class BottomMenuBarCell: UICollectionViewCell {

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
