//
//  MovieList.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 16/12/25.
//

import Foundation

struct MovieResponse: Codable, Sendable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
