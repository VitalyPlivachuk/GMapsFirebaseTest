//
//  VPProfileViewModel.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift
import RxOptional


class VPProfileViewModel{
    
    let disposeBag = DisposeBag()
    
    let profileImage = BehaviorSubject<UIImage>(value: #imageLiteral(resourceName: "userAvatar"))
    let name = BehaviorSubject<String>(value: "")
    let email = BehaviorSubject<String>(value: "")
    let logout: AnyObserver<Void>
    
    
    init() {
        let newUser = VPGoogleClient.shared.user
            .asObservable()
            .filterNil()
        
        let _logout = PublishSubject<Void>()
        self.logout = _logout.asObserver()
        _logout.asObservable()
            .subscribe(onNext:{
                VPGoogleClient.shared.logout()
            })
        .disposed(by: disposeBag)
        
        newUser.map{$0.displayName}
            .map{$0 ?? ""}
            .bind(to: name)
            .disposed(by: disposeBag)
        
        newUser.map{$0.email}
            .map{$0 ?? ""}
            .bind(to: email)
            .disposed(by: disposeBag)
        
        newUser.map{$0.photoURL}
            .subscribeOn(MainScheduler.instance)
            .do{[weak self] in self?.profileImage.onNext(#imageLiteral(resourceName: "userAvatar"))}
            .map{$0}
            .filterNil()
            .flatMap{URLSession.shared.rx.response(request: URLRequest(url: $0))}
            .map{_,data in UIImage(data: data)}
            .filterNil()
            .bind(to: profileImage)
            .disposed(by: disposeBag)
    }
}
