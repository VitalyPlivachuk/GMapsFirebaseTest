//
//  VPLocationsListViewController.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/2/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import RxOptional

class VPLocationsListViewController: UIViewController{
    var viewModel: VPLocationsListViewModel?
    
    let disposeBag = DisposeBag()
    let tableView = UITableView(frame: .zero)
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViews()
        bindToViewModel()
    }
    
    func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.expandToSafeArea()
        } else {
            tableView.expandToSuperview()
        }
        tableView.register(UINib(nibName: "VPLocationTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let noItemsLabel = UILabel.init()
        noItemsLabel.textAlignment = .center
        noItemsLabel.text = "No items"
        tableView.backgroundView = noItemsLabel
        tableView.rowHeight = 80
    }
    
    func bindViews(){
        tableView.rx.itemSelected
            .subscribe(onNext: {[unowned self] in self.tableView.deselectRow(at: $0, animated: true)})
            .disposed(by: disposeBag)
    }
    
    func bindToViewModel() {
        if let viewModel = self.viewModel{
            viewModel.favoriteLocations
                .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: VPLocationTableViewCell.self)){row,element, cell in
                    cell.titleLabel.text = element.title
                    cell.latitudeLabel.text = element.latitude
                    cell.longitudeLabel.text = element.longitude
                }
                .disposed(by: disposeBag)
            
            viewModel.favoriteLocations
                .map{!$0.isEmpty}
                .do(onNext:{[weak self] in self?.tableView.separatorStyle = $0 ? .singleLine : .none})
                .bind(to: tableView.backgroundView!.rx.isHidden)
                .disposed(by: disposeBag)
            
            tableView.rx.longPressGesture().when(.began)
                .map{[unowned self] in $0.location(in: self.tableView)}
                .map{[unowned self] in self.tableView.indexPathForRow(at: $0)}
                .filterNil()
                .map{$0.item}
                .map{[unowned self] in try? self.viewModel?.favoriteLocations.value()[$0]}
                .filterNil()
                .filterNil()
                .map{$0.model}
                .bind(to: viewModel.longTappedLocation)
                .disposed(by: disposeBag)
            
            
            viewModel.askForDelete
                .flatMap{[unowned self] in
                    self.confirmAlert($0, title: "Delete", message: nil, okButton: "Yes", cancelButton: "No")
                }
                .filterNil()
                .bind(to: viewModel.confirmedToDelete)
                .disposed(by: disposeBag)
            
            tableView.rx.modelSelected(VPLocationsListTableViewRepresentable.self)
                .map{$0.model}
                .bind(to: viewModel.selectedLocation)
                .disposed(by: disposeBag)
        }
    }
}

