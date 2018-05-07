//
//  ViewController.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 9/30/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    }
//    
//    @objc func handleKeyboardWillShow(notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            print(keyboardRectangle.height)
//
//        }
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
//        UIView.animate(withDuration: keyboardDuration!) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    @objc func handleKeyboardWillHide(notification: Notification ) {
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
//        UIView.animate(withDuration: keyboardDuration!) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
}

