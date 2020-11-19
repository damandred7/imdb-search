import Foundation
import SwiftUI


class SearchManager: ObservableObject {
    @Published public var results = [SearchResult]()
    private var keyString = "9e1e8711"

    // func fetchJson(search: String, completion: @escaping ([SearchResult]) -> Void) {
    func search(for searchString: String) {
        guard let url = url(search: searchString) else { return }
        SearchResultJSON.parse(from: url) { result in
            DispatchQueue.main.async {
                self.results = result.Search.map { $0 as SearchResult }
            }
        }
    }

    func url(search: String) -> URL? {
        let urlString = "https://www.omdbapi.com/?s=\(search)&type=movie&apikey=\(keyString)"
        return URL(string: urlString)
    }
}
