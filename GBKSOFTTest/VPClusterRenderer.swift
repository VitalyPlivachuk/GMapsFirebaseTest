//
//  VPClusterRenderer.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/4/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//


class VPClusterRenderer: GMUDefaultClusterRenderer{
    
    let maxClusterZoom:Float = 17
    let minClusterSize:UInt = 3
    
    override func shouldRender(as cluster: GMUCluster, atZoom zoom: Float) -> Bool {
        return cluster.count >= minClusterSize && zoom <= maxClusterZoom
    }
    
}
