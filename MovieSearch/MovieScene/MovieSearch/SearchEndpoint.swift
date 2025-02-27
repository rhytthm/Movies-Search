//
//  SearchEndpoint.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

import Foundation

enum MovieSceneEndpoints {
    case search(text: String)
    case image(path: String?)
}

extension MovieSceneEndpoints: Endpoint {
    var method: HttpMethod {
        .get
    }
    
    var scheme: String {
        "https"
    }
    
    var path: String {
        "/3/search/movie"
    }
    
    var imgUrl: String? {
        switch self {
        case .image(path: let path):
            return "https://image.tmdb.org/t/p/w500" + (path ?? "")
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        let apiKey = Bundle.main.infoDictionary?["ApiKey"] as? String
        return  ["Authorization": "Bearer \(apiKey ?? "")"]
    }
    
    var queryItems: [String : String]? {
        switch self {
        case .search(text: let text):
            return ["query": text]
        default:
            return nil
        }
    }
    
    var bodyParams: [String : Any]? {
        return nil
    }
}
