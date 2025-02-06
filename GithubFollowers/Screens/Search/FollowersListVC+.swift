//
//  FollowersListVC+functions.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 25/01/25.
//

import UIKit



enum Section {
    case main
}




//MARK: CollectionView in FollowersListVC
extension FollowersListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    func configureCollectionView() {
        guard let collectionView else { return }
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(FollowersCell.self, forCellWithReuseIdentifier: FollowersCell.identifier)
        return collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3 // Adjust the number of cells per row
        let padding: CGFloat = 8 // Adjust based on insets
        let minimumLineSpacing: CGFloat = 5
        
        let totalPadding = padding * (numberOfCellsPerRow + 1)
        let availableWidth = view.bounds.width - totalPadding - minimumLineSpacing*2
        let cellWidth = availableWidth / numberOfCellsPerRow
        let cellHeight = cellWidth + 40 // Add extra space for the label
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    func configureDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, FollowersModel>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCell.identifier, for: indexPath) as? FollowersCell else {
                return UICollectionViewCell()
            }
            cell.configure(follower: itemIdentifier)
            return cell
        }
    }
    
    func updateData(_ followersArray: [FollowersModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowersModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followersArray)
        dataSource?.apply(snapshot, animatingDifferences: true)
        if followers.isEmpty {
            self.showEmptyView(message: "This user doesn't have any followers")
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight {
            guard hasMoreFollers else { return }
            page += 1
        }
    }
}
