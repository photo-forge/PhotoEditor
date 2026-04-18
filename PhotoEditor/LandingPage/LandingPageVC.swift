//
//  LandingPageVC.swift
//  PhotoEditor
//
//  Created by Shah Sawda on 4/17/26.
//

import UIKit
import Mantis

class LandingPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let imgPickerVC = self.storyboard?.instantiateViewController(identifier: "IMAGE_PICKER") as! PEImagePickerVC
        imgPickerVC.fromForGround = true
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }

}

