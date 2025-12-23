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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure (with path: String?, isHero: Bool, apiService: APIService) {
        guard let path = path else { return }
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        imageView.image = nil
    }
}
