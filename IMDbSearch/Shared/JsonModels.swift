//
//  JsonModels.swift
//  IMDbSearch
//
//  Created by Anderson, Marshall on 11/18/20.
//

import Foundation

func fetchJson(search: String, completion: @escaping ([SearchResult]) -> Void) {
    // print("**** fetchJson()")
    // let urlString = "https://www.omdbapi.com/?s=guardians&type=movie&apikey=9e1e8711"
    let urlString = "https://www.omdbapi.com/?s=\(search)&type=movie&apikey=9e1e8711"
    guard let url = URL(string: urlString) else { return }
    // print("**** url: \(url)")
    URLSession.shared.dataTask(with: url) { data, response, error in
        // print("response: \(response)")
        // print("error: \(error)")
        // print(data, response, error)
        guard let data = data else { return }
        // print("data: \(data)")
        // let dataString = String(data: data, encoding: .utf8)
        // print(dataString)
        let searchResults = Bundle.main.decode(SearchResultJSON.self, from: data)
        // print(searchResults.description)
        // let convertedResults = searchResults.Search.forEach {
        //     print($0.convertedResult)
        // }
        // let convertedResults =
         DispatchQueue.main.async {
            completion(searchResults.Search.map { $0.convertedResult })
         }
    }.resume()
}



struct SearchResult {
    enum ItemType: String {
        case series
        case movie
        case episode
        case game

        static func from(string: String) -> ItemType? {
            switch string {
                case "series":
                    return .series
                case "movie":
                    return .movie
                case "episode":
                    return .episode
                case "game":
                    return .game
                default:
                    return nil
            }
        }
    }

    let title: String
    let year: String
    let id: String
    let type: ItemType?
    let posterURL: URL?
}


class SearchResultJSON: Codable {
    let Search: [SingleSearchResultJSON]
    let totalResults: String
    let Response: String

    var description: String {
        return """
            Total Results: \(totalResults)
            Response: \(Response)
            Result Content: \(searchDescriptions.joined(separator: "\n"))
        """
    }

    private var searchDescriptions: [String] {
        return Search.map { $0.description }
    }
}

class SingleSearchResultJSON: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String
    let Poster: String

    var description: String {
        return "Title: \(Title),\t Year: \(Year),\t ID: \(imdbID),\t Type: \(Type),\t Poster URL: \(Poster)"
    }

    var convertedResult: SearchResult {
        return SearchResult(
                title: Title,
                year: Year,
                id: imdbID,
                type: SearchResult.ItemType.from(string: Type),
                posterURL: URL(string: Poster))
    }
}


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        return decode(type, from: data)
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode from bundle: \(error.localizedDescription)")
        }
    }
}
