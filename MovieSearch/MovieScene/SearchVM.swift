//
//  SearchVM.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

class SearchVM {
    var movies: MoviesModel?
    func getMoviews(searchText: String, completion: @escaping (()->Void)) {
        NetworkManager.shared.sendRequest(endpoint: MovieSceneEndpoints.search(text: searchText)) {(response: Result<MoviesModel,Error>) in
            switch response {
            case .success(let movies):
                self.movies = movies
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
