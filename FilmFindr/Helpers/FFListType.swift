//
//  FFListType.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 23/12/25.
//

import Foundation

enum FFListType: String, CaseIterable {
    case popularMovies = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcomingMovies = "/movie/upcoming"
    case nowPlaying = "/movie/now_playing"
}
