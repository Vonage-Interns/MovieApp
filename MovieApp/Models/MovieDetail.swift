//  MovieDetail.swift
//  MovieApp
//  Created by Automated Assistant on 10/11/25.
//
//  Model for detailed movie info fetched via imdbID.

import Foundation

struct Rating: Codable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

struct MovieDetail: Codable, Identifiable {
    // Basic identifiers
    let imdbID: String
    var id: String { imdbID }
    
    // Fields we care about
    let title: String
    let year: String
    let released: String
    let director: String
    let writer: String
    let imdbRating: String
    let runtime: String
    let boxOffice: String
    let awards: String
    let poster: String
    let ratings: [Rating]?
    
    // Coding keys map to JSON fields
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case director = "Director"
        case writer = "Writer"
        case imdbRating
        case runtime = "Runtime"
        case boxOffice = "BoxOffice"
        case awards = "Awards"
        case poster = "Poster"
        case imdbID
        case ratings = "Ratings"
    }
    
    // Extract only Internet Movie Database rating if present
    var imdbSourceRating: String? {
        ratings?.first { $0.source == "Internet Movie Database" }?.value
    }
}