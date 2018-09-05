//
//  VPTabBarCoordinator.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/4/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class VPTabBarCoordinator: BaseCoordinator<Void>{
    
    private let window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let tabBarController = UITabBarController()
        
        let locationListCoordinator = VPLocationsListCoordinator(tabBarController: tabBarController)
        let mapCoordinator = VPMapViewCoordinator(tabBarController: tabBarController)
        let profileCoordinator = VPProfileCoordinator(tabBarController: tabBarController)
        
        locationListCoordinator.locationToShow
            .do(onNext:{_ in tabBarController.selectedIndex = 1})
            .bind(to: mapCoordinator.locationToShow)
            .disposed(by: disposeBag)
        
        coordinate(to: locationListCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        coordinate(to: mapCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        coordinate(to: profileCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        VPGoogleClient.shared.user.asObservable()
            .filter{$0 == nil}
            .subscribe(onNext:{[weak self] _ in
                self?.showLoginScreen()
            })
            .disposed(by: disposeBag)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    func showLoginScreen() {
        guard let rootVC = window?.rootViewController else {return}
        let loginCoordinator = VPLoginCoordinator(viewController: rootVC)
        coordinate(to: loginCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
