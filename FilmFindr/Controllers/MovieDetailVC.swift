//
//  MovieDetailVC.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 18/12/25.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    var movie: Movie?
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.contentsGravity = .resizeAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = movie?.title
        return label
    }()
    
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var overViewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = movie?.overview
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupNavTitle()
        configureMetaData()
        
        Task {
            await fetchMovieDetails()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIHelper.addGradient(to: backdropImageView, color: .systemBackground)
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(backdropImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(metaDataStackView)
        scrollView.addSubview(overViewLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backdropImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            backdropImageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 340),
            
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            metaDataStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            metaDataStackView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            
            overViewLabel.topAnchor.constraint(equalTo: metaDataStackView.bottomAnchor, constant: 24),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overViewLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func configureMetaData() {
        metaDataStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let movie = movie else { return }
        guard let releaseDate = movie.releaseDate else { return }
        
        let year = String(releaseDate.prefix(4))
        let runTimeValue = movie.runtime ?? 0
        let voteAverageValue = String(format: "%.1f", movie.voteAverage ?? 0.0)
        let voteAverage = UIHelper.createMetaDataItem(text: "\(voteAverageValue)/10", symbolName: "star.circle")
        let yearItem = UIHelper.createMetaDataItem(text: year, symbolName: "calendar")
        let runtime = UIHelper.createMetaDataItem(text: "\(runTimeValue) min", symbolName: "stopwatch")
        
        metaDataStackView.addArrangedSubview(yearItem)
        metaDataStackView.addArrangedSubview(runtime)
        metaDataStackView.addArrangedSubview(voteAverage)
    }
    
    private func setupNavTitle() {
        navigationItem.title = nil
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func fetchMovieDetails() async {
        guard let id = movie?.id else { return }
        do {
            let apiService = APIService()
            let detailedMovie = try await apiService.fetchMovieDetails(for: id)
            
            self.movie = detailedMovie
            
            await MainActor.run {
                self.configureMetaData()
            }
            
            if let path = detailedMovie.backdropPath {
                let urlString = "https://image.tmdb.org/t/p/w1280\(path)"
                let image = try await apiService.downloadImage(from: urlString)
                self.backdropImageView.image = image
            }
        } catch {
            print("error loading details: \(error)" )
        }
    }
}
