//
//  ViewController.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 15/12/25.
//

import UIKit

class MovieListVC: UIViewController {
    
    let apiService = APIService()
    private var movies: [Movie] = []
    private var movies2: [Movie] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        Task {
            await testFetchPopularMovies()
            await testFetchTopRatedMovies()
        }
    }
    
    func testFetchPopularMovies() async {
        do {
            let response = try await apiService.fetchMovieList(for: FFListType.popularMovies)
            
            self.movies = response.results
            print("Successfully loaded \(movies.count) movies")
            print("First movie \(movies.first!.title)")
        } catch {
            print("failed to load movies with error: \(error)")
        }
        
    }
    
    func testFetchTopRatedMovies() async {
        do {
            let response = try await apiService.fetchMovieList(for: FFListType.topRated)
            
            self.movies2 = response.results
            print("Movies loaded \(movies2.count) movies")
            print("First top rated \(movies2.first!.title)")
        } catch {
            print("failed to load movies with error: \(error)")
        }
    }
    
}
    
