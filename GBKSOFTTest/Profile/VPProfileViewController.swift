//
//  VPProfileViewController.swift
//  GBKSOFTTest
//
//  Created by Vitaly Plivachuk on 9/5/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VPProfileViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    let disposeBag = DisposeBag()
    
    var viewModel: VPProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }
    
    func bindViews(){
        logoutButton.rx.tap.asObservable()
            .bind(to: viewModel!.logout)
        .disposed(by: disposeBag)
        
        viewModel?.email
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.profileImage
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
}
