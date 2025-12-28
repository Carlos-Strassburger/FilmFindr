//
//  APIService.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import UIKit

class APIService {
    
    private let bearerToken: String
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageCache = NSCache<NSString, UIImage>()
    
    init() {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: url) as? [String: Any],
              let token = dictionary["TMDB_BEARER_TOKEN"] as? String else {
            fatalError("Missing TMDB_BEARER_TOKEN in Secrets.plist")
        }
        self.bearerToken = token
    }
    
    func authenticatedRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw FFError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw FFError.invalidData
        }
        
        imageCache.setObject(image, forKey: cacheKey)
        return image
    }
    
    func fetchMovieList(for type: FFListType) async throws -> MovieResponse {
        guard let url = URL(string: baseURL + type.rawValue) else {
            throw FFError.invalidURL
        }
        
        let request = authenticatedRequest(for: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FFError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieResponse.self, from: data)
        } catch {
            throw FFError.invalidData
        }
    }
    
    func fetchMovieDetails(for id: Int) async throws -> Movie {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            throw FFError.invalidURL
        }
        
        let request = authenticatedRequest(for: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FFError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Movie.self, from: data)
        } catch {
            throw FFError.invalidData
        }
    }
}
