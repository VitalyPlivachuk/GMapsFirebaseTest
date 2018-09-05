//
//  VPProfileCoordinator.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift

class VPProfileCoordinator: BaseCoordinator<Void> {
    
    weak var tabBarController:UITabBarController?
    
    init(tabBarController:UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() -> Observable<Void> {
        let profileViewController = VPProfileViewController(nibName: "VPProfileViewController", bundle: nil)
        let viewModel = VPProfileViewModel()
        profileViewController.viewModel = viewModel
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "user"), tag: 2)
        
        tabBarController?.addChildViewController(profileViewController)
        return Observable.never()
    }
}
