//
//  VPMapViewController.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/3/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import GoogleMaps
import UIKit
import RxSwift
import RxCocoa

class VPMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    let disposeBag = DisposeBag()
    var viewModel: VPMapViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        bindViewModel()
    }
    
    private func setUpMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [9], backgroundImages: [#imageLiteral(resourceName: "clusterIcon")])
        let renderer = VPClusterRenderer(mapView: mapView,
                                         clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView,
                                           algorithm: algorithm,
                                           renderer: renderer)
        
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    func bindViewModel(){
        guard let viewModel = viewModel else {return}
        viewModel.locationToShow
            .subscribe(onNext:{[weak self] in
                self?.mapView.animate(toLocation: $0.position)
                self?.mapView.animate(toZoom: 18)
                self?.mapView.selectedMarker = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.locationByLongTap
            .flatMap{[unowned self] in
                self.textAlert($0, title: "Save", message: nil, okButton: "Ok", cancelButton: "Cancel", isValidInput: {_ in true})}
            .map{name, coord -> (String,CLLocationCoordinate2D)? in
                guard let name = name else {return nil}
                guard let coord = coord else {return nil}
                return (name, coord)
            }
            .filterNil()
            .map{VPLocationModel(name: $0.0, position: $0.1)}
            .bind(to: viewModel.locationToSave)
            .disposed(by: self.disposeBag)
        
        
        viewModel.favoriteLocations.asObserver()
            .subscribe(onNext:{[unowned self] in
                self.clusterManager.clearItems()
                self.clusterManager.add($0)
            })
            .disposed(by: disposeBag)

        viewModel.currentLocation.subscribe(onNext:{[weak self] in
            self?.mapView.animate(toLocation: $0)
        })
            .disposed(by: disposeBag)
    }
}

extension VPMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        viewModel?.locationByLongTap.onNext(coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
}

extension VPMapViewController: GMUClusterManagerDelegate{
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        mapView.animate(toLocation: cluster.position)
        return false
    }
}

extension VPMapViewController: GMUClusterRendererDelegate{
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let model = marker.userData as? VPLocationModel{
            marker.title = model.title
            marker.icon = #imageLiteral(resourceName: "markerIcon")
        }
        
    }
}
