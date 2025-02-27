//
//  Endpoint.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

protocol Endpoint {
    var method: HttpMethod { get }
    var scheme: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var headers: [String:String]? { get }
    var queryItems: [String:String]? { get }
    var bodyParams: [String:Any]? { get }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

extension Endpoint {
    var baseUrl: String {
        #if DEBUG
            return "api.themoviedb.org"
        #else
            return ""
        #endif
    }
}
