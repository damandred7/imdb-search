import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(
            action: {
                fetchJson(search: "guardians") { results in
                    results.forEach { print($0.description) }
                }
            },
            label: {
                Text("Search!")
            })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func fetchJson(search: String, completion: @escaping ([SearchResult]) -> Void) {
    let urlString = "https://www.omdbapi.com/?s=\(search)&type=movie&apikey=9e1e8711"
    guard let url = URL(string: urlString) else { return }
    SearchResultJSON.parse(from: url) { result in
        DispatchQueue.main.async {
            completion(result.Search.map { $0 as SearchResult })
        }
    }
}
