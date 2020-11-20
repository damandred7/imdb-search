import Foundation


/// Represents a single search result element
public protocol SearchResult {
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


/// For future use. This defines known types of titles.
public enum ItemType {
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
