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
    @IBOutlet weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        collectionView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        
        viewModel.title
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.users
            .do(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
            .bind(to: collectionView.rx.items(cellIdentifier: "RandomUserCell", cellType: RandomUserCellView.self)) { (index, cellViewModel, cell) in
                
                cellViewModel.removeDidTap
                    .map { IndexPath(item: index, section: 0) }
                    .bind(to: self.viewModel.userDeleted)
                    .disposed(by: cell.disposeBag)

                cell.setup(with: cellViewModel)
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
        
        collectionView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
            })
            .bind(to: viewModel.userSelected)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension RandomUserListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = (collectionView.frame.size.width - 48) / 2.0
        return CGSize(width: columnWidth, height: columnWidth * 1.55)
    }
}
