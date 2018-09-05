//
//  VPMapViewModel.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/3/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import GoogleMaps
import RxFirebase
import RxCoreLocation
import FirebaseDatabase
import RxOptional

class VPMapViewModel{
    let disposeBag = DisposeBag()
    
    let locationToShow = PublishSubject<VPLocationModel>()
    let currentLocation: Observable<CLLocationCoordinate2D>
    
    //MARK:-Inputs
    let locationByLongTap = PublishSubject<CLLocationCoordinate2D>()
    let locationToSave = PublishSubject<VPLocationModel>()
    
    
    //MARK:-Outputs
    let favoriteLocations: BehaviorSubject<[VPLocationModel]>
    
    init() {
        self.favoriteLocations = BehaviorSubject<[VPLocationModel]>(value:[])
        VPGoogleClient.shared.favoritesLocations
            .bind(to: favoriteLocations)
            .disposed(by: disposeBag)
        
        let locManager = CLLocationManager()
        locManager.startUpdatingLocation()
        self.currentLocation = locManager.rx.location
            .takeUntil(locationToShow)
            .map{$0?.coordinate}
            .filterNil()
            .take(1)
            .do(onCompleted: {locManager.stopUpdatingLocation()})
        
        
        locationToSave
            .bind(to: VPGoogleClient.shared.locationToSave)
            .disposed(by: disposeBag)
    }
}
