//
//  RandomUserListViewController.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RandomUserListViewController: UIViewController, UIScrollViewDelegate, StoryboardInitializable {
    
    var viewModel: RandomUserListViewModel!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        tableView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        
        viewModel.title
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.users
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.setContentOffset(.zero, animated: false)
            })
            .bind(to: tableView.rx.items(cellIdentifier: "RandomUserCell", cellType: RandomUserCellView.self)) { (_, viewModel, cell) in
                cell.setup(with: viewModel)
        }
        .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.showError(message: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 || self.refreshControl.isRefreshing }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.userSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}
