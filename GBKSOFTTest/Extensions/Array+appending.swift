//
//  Array+appending.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

extension Array {
    func appending(_ newElement: Element) -> Array {
        var a = Array(self)
        a.append(newElement)
        return a
    }
}
