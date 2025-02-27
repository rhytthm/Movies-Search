//
//  SearchEndpoint.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

import Foundation

enum MovieSceneEndpoints {
    case search(text: String)
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
    
    var headers: [String : String]? {
        let apiKey = Bundle.main.infoDictionary?["ApiKey"] as? String
        return  ["Authorization": "Bearer \(apiKey ?? "")"]
    }
    
    var queryItems: [String : String]? {
        switch self {
        case .search(text: let text):
            return ["query": text]
        }
    }
    
    var bodyParams: [String : Any]? {
        return nil
    }
}
