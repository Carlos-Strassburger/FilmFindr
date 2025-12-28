//
//  Movie.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import Foundation

struct Movie: Codable, Hashable, Sendable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Float?
    let overview: String?
    let runtime: Int?
}
