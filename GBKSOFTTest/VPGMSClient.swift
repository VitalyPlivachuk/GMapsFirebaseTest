//
//  VPGMSClient.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/3/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import GoogleMaps
import FirebaseDatabase

class VPGMSClient {
    
    static func modelToTableView(models:[VPLocationModel]) -> [VPLocationsListTableViewRepresentable]{
        return models.map{VPLocationsListTableViewRepresentable(model: $0)}
    }
    
    static func locations(from snapshot:DataSnapshot)->[VPLocationModel]{
        return snapshot.children.compactMap{
            let snap = $0 as! DataSnapshot
            let dict = snap.value as? [String:Any]
            return VPLocationModel(dict: dict)
        }
    }
    
}
