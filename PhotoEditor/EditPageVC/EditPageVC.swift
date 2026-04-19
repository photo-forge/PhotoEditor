//
//  EditPageVC.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/18/26.
//

import UIKit

class EditPageVC: UIViewController {
    
    var mainImage: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = mainImage
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        print("Show Discard View")
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        print("Show Share View")
    }
    
}
 
