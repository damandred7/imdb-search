//
//  JsonModels.swift
//  IMDbSearch
//
//  Created by Anderson, Marshall on 11/18/20.
//

import Foundation

func fetchJson(search: String, completion: @escaping ([SearchResult]) -> Void) {
    let urlString = "https://www.omdbapi.com/?s=\(search)&type=movie&apikey=9e1e8711"
    guard let url = URL(string: urlString) else { return }
    SearchResultJSON.parse(from: url) { result in
        DispatchQueue.main.async {
            completion(result.Search.map { $0 as SearchResult })
        }
    }
}

enum ItemType {
    case series
    case movie
    case episode
    case game
    case unknown(String)

    static func from(string: String) -> ItemType {
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
                return .unknown(string)
        }
    }
}


protocol SearchResult {
    var title: String { get }
    var year: String { get }
    var id: String { get }
    var type: ItemType { get }
    var posterURL: URL? { get }
}


extension SearchResult {
    var description: String {
        return "SearchResult(title: \(title), year: \(year), id: \(id), type: \(type), posterURL: \(posterURL?.description ?? "nil")"
    }
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

    static func parse(from url: URL, completion: @escaping (SearchResultJSON) -> Void) {
        url.fetch {
            completion(Bundle.main.decode(SearchResultJSON.self, from: $0))
        }
    }
}


extension URL {
    func fetch(completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
}


class SingleSearchResultJSON: Codable, SearchResult {
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String
    let Poster: String

    var description: String {
        return "Title: \(Title),\t Year: \(Year),\t ID: \(imdbID),\t Type: \(Type),\t Poster URL: \(Poster)"
    }

    var title: String                   { return Title }
    var year: String                    { return Year }
    var id: String                      { return imdbID }
    var type: ItemType                  { return .from(string: Type) }
    var posterURL: URL?                 { return URL(string: Poster) }
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
