//
//  VPLocationsListCoordinator.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/4/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift

class VPLocationsListCoordinator: BaseCoordinator<Void> {
    
    weak var tabBarController: UITabBarController?
    
    let locationToShow = PublishSubject<VPLocationModel>()
    
    init(tabBarController:UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() -> Observable<Void> {
        let viewController = VPLocationsListViewController()
        viewController.tabBarItem = UITabBarItem(title: "Saved",
                                                 image: #imageLiteral(resourceName: "saved"),
                                                 tag: 0)
        
        let viewModel = VPLocationsListViewModel()
        viewController.viewModel = viewModel
        viewModel.showLocation
            .bind(to: self.locationToShow)
            .disposed(by: self.disposeBag)
        
        tabBarController?.addChildViewController(viewController)
        return Observable.never()
    }
    
    private func show(location:VPLocationModel) {
    }
}
