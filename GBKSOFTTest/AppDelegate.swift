//
//  AppDelegate.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    var window: UIWindow?
    var appCoordinator: VPTabBarCoordinator!
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appCoordinator = VPTabBarCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        VPGoogleClient.shared.config()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
}

