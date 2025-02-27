//
//  MoviesModel.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

struct MoviesModel: Codable {
    var page: Int
    var results: [Movie]
}

struct Movie: Codable {
    var id: Int
    var title: String
    var overview: String?
    var imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case overview = "overview"
        case imagePath = "poster_path"
    }
}
