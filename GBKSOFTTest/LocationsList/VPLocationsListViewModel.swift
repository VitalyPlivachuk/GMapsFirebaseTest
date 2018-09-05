//
//  VPLocationsListViewModel.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import RxFirebase
import FirebaseDatabase
import RxSwift

class VPLocationsListViewModel{
    
    let disposeBag: DisposeBag
    
    //MARK:-Output
    let favoriteLocations: BehaviorSubject<[VPLocationsListTableViewRepresentable]>
    let showLocation: Observable<VPLocationModel>
    let askForDelete: Observable<VPLocationModel>
    let locationToDelete: Observable<VPLocationModel>
    
    //MARK:-Input
    let selectedLocation: AnyObserver<VPLocationModel>
    let longTappedLocation: AnyObserver<VPLocationModel>
    let confirmedToDelete: AnyObserver<VPLocationModel>
    
    init() {
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag
        
        let _selectedLocation = PublishSubject<VPLocationModel>()
        self.selectedLocation = _selectedLocation.asObserver()
        self.showLocation = _selectedLocation.asObservable()
        
        self.favoriteLocations = BehaviorSubject<[VPLocationsListTableViewRepresentable]>(value:[])
        
        VPGoogleClient.shared.favoritesLocations
            .map{VPGMSClient.modelToTableView(models: $0)}
            .bind(to: favoriteLocations)
            .disposed(by: disposeBag)
        
        let _longTappedLocation = PublishSubject<VPLocationModel>()
        self.longTappedLocation = _longTappedLocation.asObserver()
        self.askForDelete = _longTappedLocation.asObservable()
        
        let _locationToDelete: PublishSubject<VPLocationModel> = PublishSubject<VPLocationModel>()
        
        self.locationToDelete = _locationToDelete.asObservable()
        self.confirmedToDelete = _locationToDelete.asObserver()
        
        
        self.locationToDelete
            .bind(to: VPGoogleClient.shared.locationToRemove)
            .disposed(by: disposeBag)
    }
}
