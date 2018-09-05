//
//  UIAlertController+Observable.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/3/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    func textAlert<T>(_ t:T, title: String, message: String?, okButton:String, cancelButton:String, isValidInput: @escaping (String) -> Bool) -> Observable<(String?, T?)> {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = PublishSubject<T>()
        let confirmed = UIAlertAction(title: okButton, style: .default) { (action) in
            confirm.onNext(t)
        }
        let cancel = UIAlertAction(title: cancelButton, style: .default)
        
        let text = PublishSubject<String>()
        alert.addTextField { textField in
            textField.placeholder = "Enter Data"
            _ = textField.rx.text.orEmpty.bind(to: text)
        }
        
        _ = text.map(isValidInput)
            .bind(to: confirmed.rx.isEnabled)
        
        alert.addAction(cancel)
        alert.addAction(confirmed)
        
        present(alert, animated: true, completion: nil)
        return confirm.withLatestFrom(text, resultSelector: { t, text in
            return (text, t)
        })
    }
    
    func confirmAlert<T>(_ t:T, title: String?, message: String?, okButton:String?, cancelButton:String?) -> Observable<T?> {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = PublishSubject<T?>()
        let confirmed = UIAlertAction(title: okButton, style: .default) { (action) in
            confirm.onNext(t)
        }
        
        let cancel = UIAlertAction(title: cancelButton, style: .default){ (action) in
            confirm.onNext(nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirmed)
        
        present(alert, animated: true, completion: nil)
        return confirm.asObservable()
    }
}
