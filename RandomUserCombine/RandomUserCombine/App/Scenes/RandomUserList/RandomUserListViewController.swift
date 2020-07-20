//
//  RandomUserListViewController.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

class RandomUserListViewController: UIViewController, StoryboardInitializable {
    
    var viewModel: RandomUserListViewModel!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private var selectedUserFrame: CGRect?

    // MARK: - DiffableDataSource / Compositional layout
    
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
                .sink(receiveValue: { [weak self] user in
                    self?.viewModel.userDeleted.send(user)
                })
                .store(in: &cell.cancellables)
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
    
    fileprivate func createLayout() -> UICollectionViewLayout {
        let spacing = Styles.Constants.listPadding

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(Styles.Constants.userAspectRatio / 2.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        viewModel.reload.send(())
    }
    
    private func setupBindings() {
        
        viewModel.$title
            .map { $0 }
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
        
        viewModel.$users
            .handleEvents(receiveOutput: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] users in
                guard let strongSelf = self else { return }
                strongSelf.createSnapshot(with: users)
            })
            .store(in: &cancellables)

        viewModel.$errorMessage
            .filter { $0 != nil }
            .sink(receiveValue: { [weak self] message in
                self?.refreshControl.endRefreshing()
                self?.showError(message: message!)
            })
            .store(in: &cancellables)

        viewModel.$isLoading
            .map { !$0 || self.refreshControl.isRefreshing }
            .sink(receiveValue: { [weak self] shouldHide in
                self?.loadingView.isHidden = shouldHide
            })
            .store(in: &cancellables)
        
        refreshControl.publisher(for: .valueChanged)
            .sink(receiveValue: { [weak self] _ in
                self?.viewModel.reload.send(())
            })
            .store(in: &cancellables)
    }
}

extension RandomUserListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let userId = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        if let cell = collectionView.cellForItem(at: indexPath) {
            selectedUserFrame = cell.contentView.convert(cell.contentView.frame, to: view)
        }
        viewModel.userSelected.send(userId)
    }
}

extension RandomUserListViewController: Zoomable {
    var zoomableViewFrame: CGRect {
        self.selectedUserFrame ?? .zero
    }
}
