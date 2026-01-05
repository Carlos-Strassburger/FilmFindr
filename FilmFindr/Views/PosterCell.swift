//
//  PosterCell.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 18/12/25.
//
import UIKit

class PosterCell: UICollectionViewCell {
    
    static let identifier = "PosterCell"
    private var downloadTask: Task<Void, Never>?
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        
        label.shadowColor = .black.withAlphaComponent(0.8)
        label.shadowOffset = CGSizeMake(1, 1)
        label.isHidden = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !titleLabel.isHidden {
            UIHelper.addHeroGradient(to: imageView)
            contentView.bringSubviewToFront(titleLabel )
        } else {
            imageView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        }
    }
    
    func configure (with movie: Movie, isHero: Bool, apiService: APIService) {
        titleLabel.isHidden = !isHero
        titleLabel.text = isHero ? movie.title : nil
        
        let path = isHero ? movie.backdropPath : movie.posterPath
        guard let path = path else {
            self.imageView.image = UIImage(named: "poster-placeholder")
            return
        }
        
        let quality = isHero ? "w1280" : "w500"
        let urlString = "https://image.tmdb.org/t/p/\(quality)\(path)"
        
        downloadTask?.cancel()
        
        downloadTask = Task {
            do {
                let image = try await apiService.downloadImage(from: urlString)
                
                if !Task.isCancelled {
                    self.imageView.image = image
                }
            } catch {
                self.imageView.image = UIImage(named: "poster-placeholder")
            }
        }
        
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        imageView.image = nil
        titleLabel.text = nil
        titleLabel.isHidden = true
        imageView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}
