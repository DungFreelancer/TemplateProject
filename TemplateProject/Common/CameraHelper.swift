//
//  CameraHelper.swift
//  TemplateProject
//
//  Created by apple on 9/7/19.
//  Copyright © 2019 HD. All rights reserved.
//

import UIKit

class CameraHelper: NSObject {
    
    static let shared = CameraHelper()
    
    private override init() {}
    
    private var complete: ((UIImage?)->())?
    
    private var cancel: (()->())?
    
    func showCamera(on vc: UIViewController, complete: @escaping (UIImage?)->(), cancel: (()->())? = nil) {
//        Add 2 keys into Info.plist:
//        <key>NSCameraUsageDescription</key>
//        <string>${PRODUCT_NAME} Camera Usage</string>
//        <key>NSPhotoLibraryUsageDescription</key>
//        <string>${PRODUCT_NAME} PhotoLibrary Usage</string>
        
        self.complete = complete
        self.cancel = cancel
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        AlertHelper.showActionSheet(on: vc, title: "Photo Source", message: nil, firstButton: "Camera", firstComplete: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                vc.present(picker, animated: true, completion: nil)
            } else {
                Log.e("Camera is not available!!!")
                complete(nil)
            }
        }, secondButton: "Photo Library", secondComplete: { (action:UIAlertAction) in
            picker.sourceType = .photoLibrary
            vc.present(picker, animated: true, completion: nil)
        })
    }
    
}

extension CameraHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        self.complete!(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.cancel!()
    }
    
}
