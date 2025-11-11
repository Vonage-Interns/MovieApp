//
//  APIManager.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    func fetchMovies(search: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
            print("Missing OMDB_API_KEY in Info.plist")
            return
        }
   

        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(search)&page=\(page)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decoded.search ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
            completion(.failure(NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing OMDB_API_KEY in Info.plist"])))
            return
        }
        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "API", code: -2, userInfo: [NSLocalizedDescriptionKey: "Bad URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else { return }
            do {
                let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct MovieResponse: Codable {
    let search: [Movie]?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
