//
//  APIService.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import Foundation

class APIService {
    
    private let bearerToken: String
    private let baseURL = "https://api.themoviedb.org/3"
    
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
    
}

enum FFError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

enum FFListType: String {
    case popularMovies = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcomingMovies = "/movie/upcoming"
}
