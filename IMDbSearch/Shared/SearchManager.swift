import Foundation
import SwiftUI


/// Manager search requests, results, and detail (indirectly)
public class SearchManager: ObservableObject {
    @Published public var results = [SearchResultWithDetail]()
    static internal var KeyString = "9e1e8711"
    @Published public var searchText = "" {
        didSet {
            search(for: searchText)
        }
    }

    public func search(for searchString: String) {
        guard let url = buildSearchURL(search: searchString) else { return }
        SearchResultJSON.parse(from: url) { result in
            DispatchQueue.main.async {
                self.results = result.Search.map { SearchResultWithDetail(result: $0 as SearchResult) }
            }
        }
    }

    private func buildSearchURL(search: String) -> URL? {
        let urlString = "https://www.omdbapi.com/?s=\(search)&type=movie&apikey=\(SearchManager.KeyString)"
        return URL(string: urlString)
    }
}


/// Store a single search result and load detail for that result as requested
public class SearchResultWithDetail: ObservableObject {
    @Published var result: SearchResult
    @Published var detail: TitleDetail?

    public init(result: SearchResult) {
        self.result = result
    }

    public func requestDetail() {
        guard let url = buildTitleURL(imdbID: result.id) else { return }
        TitleDetailJSON.parse(from: url) { result in
            DispatchQueue.main.async {
                self.detail = result as TitleDetail
            }
        }
    }

    private func buildTitleURL(imdbID: String) -> URL? {
        let urlString = "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(SearchManager.KeyString)"
        return URL(string: urlString)
    }
}
