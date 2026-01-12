//
//  UIHelper.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 23/12/25.
//

import UIKit

enum UIHelper {
    
    static func createHomeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let isBigSection = (sectionIndex == 0)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let groupWidth = isBigSection ? NSCollectionLayoutDimension.fractionalWidth(0.9) : .fractionalWidth(0.35)
            let groupHeight = isBigSection ? NSCollectionLayoutDimension.absolute(250) : .absolute(180)
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = isBigSection ? .groupPagingCentered : .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            
            section.boundarySupplementaryItems = [headerItem]
            return section
        }
    }
    
    static func addGradient(to imageView: UIImageView, color: UIColor) {
        imageView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor,
            UIColor.black.cgColor
        ]
        
        gradient.locations = [0.4, 0.8, 1.0]
        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    static func addHeroGradient(to imageView: UIImageView) {
        imageView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        
        gradient.frame = imageView.bounds
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.withAlphaComponent(0.95).cgColor
        ]

        gradient.locations = [0.3, 0.7, 1.0]

        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    static func createTableStyleLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func createMetaDataItem(text: String, symbolName: String) -> UIStackView {
        let icon = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        icon.image = UIImage(systemName: symbolName, withConfiguration: config)
        icon.tintColor = .secondaryLabel
        icon.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [icon, label])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }
}
