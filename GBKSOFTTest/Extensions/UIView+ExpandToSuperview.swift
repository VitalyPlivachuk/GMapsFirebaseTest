//
//  UIView+ExpandToSuperview.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/3/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit

extension UIView{
    
    @available(iOS 11.0, *)
    func expandToSafeArea(){
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {return}
        let layoutGuide = superview.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            self.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            self.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor)
            ])
    }
    
    func expandToSuperview(){
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {return}
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor)
            ])
    }
    
    
}
