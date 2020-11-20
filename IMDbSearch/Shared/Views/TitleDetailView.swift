import SwiftUI


/// Shows detail for a single movie
struct TitleDetailView: View {
    @ObservedObject var searchResult: SearchResultWithDetail
    var yearText: String {
        guard let year = searchResult.detail?.year else { return "" }
        return " (\(year))"
    }

    var body: some View {
        List {
            if let url = searchResult.detail?.posterURL {
                AsyncImage<Image>(url: url,
                           placeholder: Image(systemName: "photo").resizable())
            }
            Text("\(searchResult.result.title)\(yearText)")
                .font(.headline)
            if let detail = searchResult.detail {
                Text("Directed by: \(detail.directors.joined(separator: ", "))")
                Text("Actors: \(detail.actors.joined(separator: ", "))")
            }
        }
        .onAppear {
            searchResult.requestDetail()
        }
    }
}
