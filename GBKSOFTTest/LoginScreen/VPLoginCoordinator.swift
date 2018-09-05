//
//  VPLoginCoordinator.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//


import UIKit
import RxSwift

class VPLoginCoordinator: BaseCoordinator<Void> {
    
    weak var viewController:UIViewController?
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
    override func start() -> Observable<Void> {
        let loginViewController = VPLoginViewController(nibName: "VPLoginViewController", bundle: nil)
        
        VPGoogleClient.shared.user.asObservable()
            .filterNil()
            .subscribe(onNext: {_ in
                loginViewController.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
      viewController?.present(loginViewController, animated: true)
        return Observable.never()
    }
}
