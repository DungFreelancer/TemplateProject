//
//  ViewController.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 9/30/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    enum SwitchAnimation {
        case top, bottom, fade
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settupViews()
    }
    
    // MARK: - private function
    private func settupViews() {
        self.navigationController?.isNavigationBarHidden = true
        
        let tapCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapCloseKeyboard)
        tapCloseKeyboard.cancelsTouchesInView = false
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    func backToRoot(animation: SwitchAnimation = .fade) {
        self.switchToAnimation(animation)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func show(_ vc: UIViewController, animation: SwitchAnimation) {
        self.switchToAnimation(animation)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func hidden(animation: SwitchAnimation = .fade) {
        self.switchToAnimation(animation)
        self.navigationController?.popViewController(animated: false)
    }
    
    private func switchToAnimation(_ animation: SwitchAnimation) {
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        switch animation {
        case .top:
            transition.type = .push
            transition.subtype = .fromTop
        case .bottom:
            transition.type = .push
            transition.subtype = .fromBottom
        case .fade:
            transition.type = .fade
        }
        
        self.navigationController?.view.layer.removeAnimation(forKey: "ShowAnimation")
        self.navigationController?.view.layer.add(transition, forKey: "ShowAnimation")
    }
}
