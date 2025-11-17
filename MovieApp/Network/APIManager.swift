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


    
    // Async/Await variant
    @discardableResult
    func fetchMovies(search: String, page: Int) async throws -> [Movie] {
        //safe early exit if api key is missing
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
            throw NSError(domain: "API", code: -10, userInfo: [NSLocalizedDescriptionKey: "Missing OMDB_API_KEY in Info.plist"]) }
        //make ready URL
        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(search)&page=\(page)"
        // check for valid URL
        guard let url = URL(string: urlString) else { throw NSError(domain: "API", code: -11, userInfo: [NSLocalizedDescriptionKey: "Bad URL"]) }
        // create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // perform request
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decoded.search ?? []
    }
    
    
    // Async/Await variant
    @discardableResult
    func fetchMovieDetail(imdbID: String) async throws -> MovieDetail {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
            throw NSError(domain: "API", code: -20, userInfo: [NSLocalizedDescriptionKey: "Missing OMDB_API_KEY in Info.plist"]) }
        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)"
        guard let url = URL(string: urlString) else { throw NSError(domain: "API", code: -21, userInfo: [NSLocalizedDescriptionKey: "Bad URL"]) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
        return detail
    }
}

struct MovieResponse: Codable {
    let search: [Movie]?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}




    
    //    func fetchMovies(search: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
    //        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
    //            print("Missing OMDB_API_KEY in Info.plist")
    //            return
    //        }
    //
    //
    //        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(search)&page=\(page)"
    //        guard let url = URL(string: urlString) else { return }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //
    //        URLSession.shared.dataTask(with: request) { data, _, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //            guard let data = data else { return }
    //
    //            do {
    //                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
    //                completion(.success(decoded.search ?? []))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
    
    
    //
//    func fetchMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String else {
//            completion(.failure(NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing OMDB_API_KEY in Info.plist"])))
//            return
//        }
//        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)"
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "API", code: -2, userInfo: [NSLocalizedDescriptionKey: "Bad URL"])))
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                completion(.failure(error)); return
//            }
//            guard let data = data else { return }
//            do {
//               let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
//                completion(.success(detail))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    

