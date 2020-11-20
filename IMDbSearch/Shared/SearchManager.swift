import Foundation
import SwiftUI


public class SearchManager: ObservableObject {
    @Published public var results = [SearchResultWithDetail]()
    static internal var KeyString = "9e1e8711"

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


public class SearchResultWithDetail: ObservableObject {
    @Published var result: SearchResult
    @Published var detail: TitleDetail?
    @Published var detailRequested = false

    public init(result: SearchResult) {
        self.result = result
    }

    public func requestDetail() {
        guard let url = buildTitleURL(imdbID: result.id) else { return }
        TitleDetailJSON.parse(from: url) { result in
            DispatchQueue.main.async {
                self.detail = result as TitleDetail
                print(self.detail?.description ?? "nil")
            }
        }
    }

    private func buildTitleURL(imdbID: String) -> URL? {
        let urlString = "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(SearchManager.KeyString)"
        return URL(string: urlString)
    }
}
