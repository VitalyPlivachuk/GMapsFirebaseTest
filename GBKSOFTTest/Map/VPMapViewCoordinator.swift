//
//  VPMapViewCoordinator.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/4/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift

class VPMapViewCoordinator: BaseCoordinator<Void> {
    
    weak var tabBarController: UITabBarController?
    
    var locationToShow = PublishSubject<VPLocationModel>()
    
    init(tabBarController:UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() -> Observable<Void> {
        let viewController = VPMapViewController()
        viewController.tabBarItem = UITabBarItem(title: "Map",
                                                 image: #imageLiteral(resourceName: "map"),
                                                 tag: 1)
        
        let viewModel = VPMapViewModel()
        viewController.viewModel = viewModel
        self.locationToShow
            .bind(to: viewModel.locationToShow)
            .disposed(by: self.disposeBag)

        
        tabBarController?.addChildViewController(viewController)
        return Observable.never()
    }
}
