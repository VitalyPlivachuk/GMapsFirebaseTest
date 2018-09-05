//
//  VPGoogleClient.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleMaps
import RxSwift

class VPGoogleClient: NSObject {
    
    private override init(){
    }
    
    static let shared = VPGoogleClient()
    private let mapsApiKey = "AIzaSyCHCIIU2CRTNdorjf8VsGZi7syQL5mzIDM"
    
    let user = Variable<User?>(nil)
    
    let favoritesLocations = PublishSubject<[VPLocationModel]>()
    let locationToSave = PublishSubject<VPLocationModel>()
    let locationToRemove = PublishSubject<VPLocationModel>()
    
    let disposeBag = DisposeBag()
    
    func config(){
        FirebaseApp.configure()
        GMSServices.provideAPIKey(mapsApiKey)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        user.value = Auth.auth().currentUser
        
        let dataRef = user.asObservable()
            .filterNil()
            .filter{$0 == Auth.auth().currentUser}
            .map{$0.uid}
            .map{Database.database().reference(withPath: $0)}
            .map{$0.child("favoriteLocations")}
        
        dataRef
            .flatMap{$0.rx.observeEvent(.value)}
            .map{VPGMSClient.locations(from: $0)}
            .map{$0.sorted(by: {$0.title ?? "" < $1.title ?? ""})}
            .bind(to: favoritesLocations)
            .disposed(by: disposeBag)
        
        locationToRemove
            .withLatestFrom(favoritesLocations) { toRemove, favorites in favorites.filter{$0 != toRemove}}
            .map{ models -> [[String:Any]] in
                models.map{$0.dictionary}}
            .withLatestFrom(dataRef, resultSelector: {value, reference in
                reference.setValue(value)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        
        locationToSave
            .withLatestFrom(favoritesLocations) {toRemove, favorites in favorites.appending(toRemove)}
            .map{ models -> [[String:Any]] in
                models.map{$0.dictionary}}
            .withLatestFrom(dataRef, resultSelector: {value, reference in
                reference.setValue(value)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
    
    func logout(){
        GIDSignIn.sharedInstance()?.signOut()
        try! Auth.auth().signOut()
        user.value = nil
    }
    
}

extension VPGoogleClient: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.user.value = nil
            return
        }
        
        guard let authentication = user.authentication else {self.user.value = nil; return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) {[unowned self] (authResult, error) in
            if let user = authResult?.user{
                self.user.value = user
            } else {
                self.user.value = nil
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.user.value = nil
    }
}

