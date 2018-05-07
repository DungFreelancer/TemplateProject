//
//  AdjustCardView.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 5/7/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class AdjustCardView: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
//
//    private let imagePickerController = UIImagePickerController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.imagePickerController.delegate = self
//        self.alertPopup()
//    }
//
//    func alertPopup(){
//        let actionSheet = UIAlertController(title: "Camera Mode", message: "Choose record or snapshot", preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "SnapShot", style: .default, handler: { (action:UIAlertAction) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.imagePickerController.sourceType = .camera
//                self.present(self.imagePickerController, animated: true, completion: nil)
//            } else {
//                print("Camera is not available")
//            }
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Record", style: .default, handler: { (action:UIAlertAction) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                print("Camera Available")
//                self.imagePickerController.sourceType = .camera
//                self.imagePickerController.videoMaximumDuration = 5
//                self.imagePickerController.mediaTypes = [kUTTypeMovie as String]
//                self.imagePickerController.allowsEditing = false
//                //Cancel,save recording
//                self.imagePickerController.showsCameraControls = true
//                self.present(self.imagePickerController, animated: true, completion: nil)
//            } else {
//                print("Camera is not available")
//            }
//
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
//    }
//
//
}

