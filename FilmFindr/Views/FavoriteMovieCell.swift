import UIKit

class FavoriteMovieCell: UICollectionViewCell {
    
    static let identifier = "FavoriteMovieCell"
    private var downloadTask: Task<Void, Never>?
    
    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGreen
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGreen
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(backdropImageView)
        contentView.addSubview(textStackView)
        
        // Horizontal rows for Icon + Text
        let yearRow = createIconStack(systemName: "calendar", color: .systemGreen, label: yearLabel)
        let scoreRow = createIconStack(systemName: "star.fill", color: .systemGreen, label: scoreLabel)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(yearRow)
        textStackView.addArrangedSubview(scoreRow)
        
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            backdropImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backdropImageView.widthAnchor.constraint(equalToConstant: 130),
            backdropImageView.heightAnchor.constraint(equalToConstant: 75),
            
  
            textStackView.leadingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            textStackView.centerYAnchor.constraint(equalTo: backdropImageView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func createIconStack(systemName: String, color: UIColor, label: UILabel) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = color
        icon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 14),
            icon.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }
    
    func configure(with movie: Movie, apiService: APIService) {
        titleLabel.text = movie.title
        scoreLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        
        if let releaseDate = movie.releaseDate, releaseDate.count >= 4 {
            yearLabel.text = String(releaseDate.prefix(4))
        } else {
            yearLabel.text = "N/A"
        }
        
        downloadTask?.cancel()
        downloadTask = backdropImageView.setImage(from: movie.backdropPath, apiService: apiService)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        backdropImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        scoreLabel.text = nil
    }
}
