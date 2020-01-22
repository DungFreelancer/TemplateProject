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
    
    private let picker = UIImagePickerController()
    
    private override init() {
        super.init()
        
        self.picker.delegate = self
    }
    
    private var complete: ((UIImage?)->())?
    
    private var cancel: (()->())?
    
    func showPicker(on vc: UIViewController, complete: @escaping (UIImage?)->(), cancel: (()->())? = nil) {
//        Add 2 keys into Info.plist:
//        <key>NSCameraUsageDescription</key>
//        <string>${PRODUCT_NAME} Camera Usage</string>
//        <key>NSPhotoLibraryUsageDescription</key>
//        <string>${PRODUCT_NAME} PhotoLibrary Usage</string>
        
        self.complete = complete
        self.cancel = cancel
        
        AlertHelper.showActionSheet(on: vc, title: "Photo Source", message: nil, firstButton: "Camera", firstComplete: { (action: UIAlertAction) in
            self.showCamera(on: vc, complete: complete, cancel: cancel)
        }, secondButton: "Photo Library", secondComplete: { (action:UIAlertAction) in
            self.showLibrary(on: vc, complete: complete, cancel: cancel)
        })
    }
    
    func showCamera(on vc: UIViewController, complete: @escaping (UIImage?)->(), cancel: (()->())? = nil) {
        self.complete = complete
        self.cancel = cancel
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker.sourceType = .camera
            vc.present(picker, animated: true, completion: nil)
        } else {
            Log.e("Camera is not available!!!")
            complete(nil)
        }
    }
    
    func showLibrary(on vc: UIViewController, complete: @escaping (UIImage?)->(), cancel: (()->())? = nil) {
        self.complete = complete
        self.cancel = cancel
        
        self.picker.sourceType = .photoLibrary
        vc.present(picker, animated: true, completion: nil)
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
        self.complete?(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.cancel?()
    }
    
}
