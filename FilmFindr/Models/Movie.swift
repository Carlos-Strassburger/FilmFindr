//
//  Movie.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import Foundation

nonisolated struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Float?
    let overview: String?
    let runtime: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
