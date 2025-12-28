//
//  ViewController.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 15/12/25.
//

import UIKit

class MovieListVC: UIViewController {
    
    let apiService = APIService()
    private var nowPlayingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHomeLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        setupLayout()
        Task {
            await fetchDataMovies()
        }
    }
    
    func setupLayout() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchDataMovies() async {
        do {
            let popularResponse = try await apiService.fetchMovieList(for: FFListType.popularMovies)
            let topRatedResponse = try await apiService.fetchMovieList(for: FFListType.topRated)
            let upcomingResponse = try await apiService.fetchMovieList(for: FFListType.upcomingMovies)
            let nowPlayingResponse = try await apiService.fetchMovieList(for: FFListType.nowPlaying)
            
            self.popularMovies = popularResponse.results
            self.topRatedMovies = topRatedResponse.results
            self.upcomingMovies = upcomingResponse.results
            self.nowPlayingMovies = nowPlayingResponse.results
            
            self.collectionView.reloadData()
            
        } catch {
            print("failed to load movies with error: \(error)")
        }
    }
    
    private func getMovie(for indexPath: IndexPath) -> Movie? {
        let movies: [Movie]
        
        switch indexPath.section {
        case 0: movies = nowPlayingMovies
        case 1: movies = popularMovies
        case 2: movies = topRatedMovies
        case 3: movies = upcomingMovies
        default: return nil
        }
        
        guard movies.indices.contains(indexPath.item) else { return nil }
        return movies[indexPath.item]
    }
}

extension MovieListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        FFListType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard FFListType.allCases.indices.contains(section) else {return 0}
        let listType = FFListType.allCases[section]
        
        switch listType {
        case .nowPlaying: return nowPlayingMovies.count
        case .popularMovies: return popularMovies.count
        case .topRated: return topRatedMovies.count
        case .upcomingMovies: return upcomingMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell else {
            return UICollectionViewCell()
        }
        
        let movie = getMovie(for: indexPath)
        let isHero = (indexPath.section == 0)
        
        
        let imagePath = isHero ? movie?.backdropPath : movie?.posterPath
        cell.configure(with: imagePath, isHero: isHero, apiService: self.apiService)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
        
        let titles = ["Now Playing", "Popular", "Top Rated", "Upcoming"]
        header.configure(title: titles[indexPath.section])
        
        return header
    }
}

extension MovieListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let movie = getMovie(for: indexPath) else { return }
        
        let detailVC = MovieDetailVC()
        detailVC.movie = movie
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
