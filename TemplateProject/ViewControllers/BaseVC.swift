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
    
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        let button = UIButton(type: .system)
//        button.setTitle("Done", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
//        view.addSubview(button)
//        //x, y, w and h
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        return view
//
//    }()
//
//    @objc func handleDoneButton() {
//        func handleKeyboardWillHide(notification: Notification ) {
//            let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
//            UIView.animate(withDuration: keyboardDuration!) {
//                self.view.layoutIfNeeded()
//            }
//        }
//
//    }
//
//
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
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
}

