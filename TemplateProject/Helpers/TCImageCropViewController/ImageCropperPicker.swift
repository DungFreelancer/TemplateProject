//
//  ImageCropperPicker.swift
//  Jobbird
//
//  Created by Tiziano Coroneo on 31/05/2018.
//  Copyright © 2018 DTT Multimedia. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

@objc protocol ImageCropperPickerDelegate: class {
    func imageCropperPicker(
        _ cropper: ImageCropperPicker,
        didReceive croppedImage: UIImage)

    @objc optional func imageCropperPickerDidCancelCrop(
        _ cropper: ImageCropperPicker)
}

class ImageCropperPicker: NSObject {

    enum SourceType {
        case photoLibrary
        case camera
//        case both
    }
    
//    private var disposeBag = DisposeBag()
    var cropShape: TCImageCropViewController.CropMode = .circle

    private let imagePickerController = UIImagePickerController()

    @IBOutlet weak var presenter: UIViewController?
    @IBOutlet weak var delegate: ImageCropperPickerDelegate?

    func presentPicker(withSourceType sourceType: SourceType) {
        switch sourceType {
        case .camera: self.presentImagePicker(withSourceType: .camera)
        case .photoLibrary: self.presentImagePicker(withSourceType: .photoLibrary)
//        case .both: self.presentAlertForBothSources()
            
        }
    }

//    private func presentAlertForBothSources() {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        Driver.zip(language.localizedValue(for: ["730takePhoto", "730library", "730cancel"],
//                                           requiresValue: true))
//            .asObservable()
//            .take(1)
//            .subscribe(onNext: { [weak self] (strings) in
//                let takePhoto = strings[0]
//                let library = strings[1]
//                let cancel = strings[2]
//
//                alert.addAction(UIAlertAction(
//                    title: takePhoto,
//                    style: .default,
//                    handler: { _ in self?.presentImagePicker(withSourceType: .camera) }))
//
//                alert.addAction(UIAlertAction(
//                    title: library,
//                    style: .default,
//                    handler: { _ in self?.presentImagePicker(withSourceType: .photoLibrary) }))
//
//                alert.addAction(UIAlertAction(
//                    title: cancel,
//                    style: .cancel,
//                    handler: { _ in alert.dismiss(animated: true, completion: nil) }))
//
//        }).disposed(by: disposeBag)
//
//        presenter?.present(alert, animated: true, completion: nil)
//    }

    private func presentImagePicker(
        withSourceType sourceType: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        setupNavigationBar()
        presenter?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        let style = imagePickerController.navigationBar
        
        style.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        style.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .compact)
        style.layer.borderWidth = 0.0;
        style.shadowImage = UIImage()
        style.tintColor = UIButton(type: UIButtonType.system).titleColor(for: .normal) // grab the default button color
        style.barTintColor = .white
        style.isTranslucent = false
    }
}

extension ImageCropperPicker: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }

        let cropper = TCImageCropViewController(withImage: image)
        cropper.delegate = self
        cropper.cropMode = self.cropShape
        cropper.rotationEnabled = false
        cropper.applyMaskToCroppedImage = false
        self.presenter?.present(cropper, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.imageCropperPickerDidCancelCrop?(self)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImageCropperPicker: UINavigationControllerDelegate {}

extension ImageCropperPicker: TCImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: TCImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.imageCropperPickerDidCancelCrop?(self)
    }

    func imageCropViewController(
        _ controller: TCImageCropViewController,
        didCropImage croppedImage: UIImage,
        usingCropRect cropRect: CGRect,
        rotationAngle: CGFloat) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.imageCropperPicker(self, didReceive: croppedImage)
    }
}
