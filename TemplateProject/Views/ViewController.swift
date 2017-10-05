//
//  ViewController.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 9/30/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Log.debug(NetworkHelper.sharedInstance.isConnect ?? "")
        Log.debug(NetworkHelper.sharedInstance.connectingChange({ (status) in
            print("Network status \(status)")
        }))
        

    }

  


}

