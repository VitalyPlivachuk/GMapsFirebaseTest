//
//  VPLocationModel.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import GoogleMaps
import CoreLocation

class VPLocationModel: GMSMarker, GMUClusterItem{
    var dictionary: [String:Any]{
        return ["name":title,
                "latitude":position.latitude,
                "longitude":position.longitude]
    }
    
    init(name:String, latitude:Double, longitude:Double) {
        super.init()
        self.title = name
        self.position = .init(latitude: latitude, longitude: longitude)
    }
    
    init(name:String, position:CLLocationCoordinate2D){
        super.init()
        self.title = name
        self.position = position
    }
    
    convenience init?(dict:[String:Any]?){
        guard let dict = dict else {return nil}
        guard let name = dict["name"] as? String else {return nil}
        guard let latitude = dict["latitude"] as? Double else {return nil}
        guard let longitude = dict["longitude"] as? Double else {return nil}
        self.init(name: name, latitude: latitude, longitude: longitude)
    }
}
