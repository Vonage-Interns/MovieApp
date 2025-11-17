//
//  Movie.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//
import Foundation

//codable: json to swift object vice versa
//Identifiable: uniquely identify each movie in a list
//equatable: compare two movie instances
struct Movie: Codable, Identifiable, Equatable {
    let id = UUID()
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    //Maps JSON keys to your Swift property nam
    // what are coding keys?:
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }

    // Optional: Add manual equality check for precision
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.imdbID == rhs.imdbID
    }
}
