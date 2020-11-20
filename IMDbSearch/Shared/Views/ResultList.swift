import SwiftUI


struct ResultList: View {
    @ObservedObject var manager: SearchManager

    var body: some View {
        List(manager.results, id: \.result.id) { result in
            TitleListItem(searchResult: result)
        }
    }
}


struct TitleListItem: View {
    @ObservedObject var searchResult: SearchResultWithDetail

    var body: some View {
        NavigationLink(destination: TitleDetailView(searchResult: searchResult)) {
            VStack(alignment: .leading) {
                Text(searchResult.result.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(searchResult.result.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
