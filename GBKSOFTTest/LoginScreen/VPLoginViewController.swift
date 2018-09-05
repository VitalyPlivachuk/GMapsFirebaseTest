//
//  VPLoginViewController.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import GoogleSignIn

class VPLoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
