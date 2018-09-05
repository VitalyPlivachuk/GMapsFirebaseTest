//
//  VPLocationsListTableViewRepresentable.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

struct VPLocationsListTableViewRepresentable{
    let title: String
    let latitude: String
    let longitude: String
    let model: VPLocationModel
    
    init(title:String, latitude:String, longitude:String, model:VPLocationModel) {
        self.title = title
        self.longitude = longitude
        self.latitude = latitude
        self.model = model
    }
    
    init(model:VPLocationModel) {
        self.title = model.title ?? "Unknown location"
        self.latitude = String(model.position.latitude)
        self.longitude = String(model.position.longitude)
        self.model = model
    }
}
