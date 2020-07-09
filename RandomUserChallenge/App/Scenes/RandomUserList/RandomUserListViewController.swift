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
    private var selectedUserFrame: CGRect?

    // MARK: - DiffableDataSource
    
    fileprivate enum Section: CaseIterable {
        case main
    }

    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, RandomUserCellViewModel>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RandomUserCellViewModel>

    fileprivate lazy var dataSource = {
        return DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomUserCellView.storyboardID, for: indexPath) as? RandomUserCellView
                else { return UICollectionViewCell() }
            cellViewModel.removeDidTap
                .bind(to: self.viewModel.userDeleted)
                .disposed(by: cell.disposeBag)
            cell.setup(with: cellViewModel)
            cell.accessibilityIdentifier = "collectionCellUser"
            return cell
        })
    }()
    
    fileprivate func createSnapshot(with users: [RandomUserCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        collectionView.refreshControl = refreshControl
        viewModel.reload.onNext(())
        collectionView.accessibilityIdentifier = "collectionViewUsers"
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
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                guard let strongSelf = self else { return }
                strongSelf.createSnapshot(with: users)
            })
            .disposed(by: disposeBag)

        viewModel.errorMessage
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
                if let cell = self?.collectionView.cellForItem(at: indexPath) {
                    self?.selectedUserFrame = cell.contentView.convert(cell.contentView.frame, to: self?.view)
                }
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
        let columnWidth = (collectionView.frame.size.width - Styles.Constants.defaultCornerRadius * 3.0) / 2.0
        return CGSize(width: columnWidth, height: columnWidth * Styles.Constants.userAspectRatio)
    }
}

extension RandomUserListViewController: Zoomable {
    var zoomableViewFrame: CGRect {
        self.selectedUserFrame ?? .zero
    }
}
