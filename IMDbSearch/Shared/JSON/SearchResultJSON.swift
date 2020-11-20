import Foundation

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


class SingleSearchResultJSON: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String
    let Poster: String

    var description: String {
        return "Title: \(Title),\t Year: \(Year),\t ID: \(imdbID),\t Type: \(Type),\t Poster URL: \(Poster)"
    }
}


extension SingleSearchResultJSON: SearchResult {
    public var title: String                   { return Title }
    public var year: String                    { return Year }
    public var id: String                      { return imdbID }
    public var type: ItemType                  { return .from(string: Type) }
    public var posterURL: URL?                 { return URL(string: Poster) }
}
