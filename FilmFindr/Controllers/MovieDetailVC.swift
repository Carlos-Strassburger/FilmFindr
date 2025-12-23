//
//  MovieDetailVC.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 18/12/25.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    var movieID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let id = movieID {
            print("Successfully passed id: \(id)")
        }
    }
}
