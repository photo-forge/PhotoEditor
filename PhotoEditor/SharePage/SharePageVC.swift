//
//  SharePageVC.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 8/31/26.
//

import UIKit

class SharePageVC: UIViewController {

    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (image != nil) {
            imageView.image = image
        }

    }
    
    // MARK: TopBarDelegate
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    
    
    
    

}
