//
//  FavoritesVC.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import UIKit
class FavoritesVC: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<FavoritesListSection, Movie>!
    private let apiService = APIService()
    private let emptyStateView = EmptyStateView()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.register(FavoriteMovieCell.self, forCellWithReuseIdentifier: FavoriteMovieCell.identifier)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        
        listConfig.showsSeparators = false
        
        listConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            return self?.collectionView(self!.collectionView, trailingSwipeActionsConfigurationForItemAt: indexPath)
        }
        
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FavoritesListSection, Movie>(collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieCell.identifier, for: indexPath) as? FavoriteMovieCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: movie, apiService: self.apiService)
            return cell
        }
    }
    
    private func updateData() {
        let favorites = PersistanceManager.retrieveFavorites()
        
        showEmptyState(favorites.isEmpty)
        
        var snapshot = NSDiffableDataSourceSnapshot<FavoritesListSection, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showEmptyState(_ show: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.emptyStateView.alpha = show ? 1 : 0
            self.collectionView.alpha = show ? 0 : 1
        }
        
        self.emptyStateView.isHidden = !show
        self.collectionView.isHidden = show
    }
}

extension FavoritesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let destVC = MovieDetailVC()
        destVC.movie = movie
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            guard let movie = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            PersistanceManager.updateWith(favorite: movie, actionType: .remove) { error in
                if let _ = error {
                    completion(false)
                    return
                }
                
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([movie])
                self.dataSource.apply(snapshot, animatingDifferences: true)
                
                if snapshot.itemIdentifiers.isEmpty {
                    self.showEmptyState(true)
                }
                completion(true)
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
