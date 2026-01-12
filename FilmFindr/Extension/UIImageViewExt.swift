//
//  UIImageViewExt.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 05/01/26.
//

import UIKit

extension UIImageView {
    func setImage(from path: String?, quality: String = "w500", apiService: APIService) -> Task<Void, Never>? {
        guard let path = path else {
            self.image = UIImage(named: "poster-placeholder")
            return nil
        }
        
        let urlString = "https://image.tmdb.org/t/p/\(quality)\(path)"
        
        return Task {
            do {
                let downloadedImage = try await apiService.downloadImage(from: urlString)
                
                if !Task.isCancelled {
                    self.image = downloadedImage
                }
            } catch {
                if !Task.isCancelled {
                    self.image = UIImage(named: "poster-placeholder")
                }
            }
        }
    }
}
