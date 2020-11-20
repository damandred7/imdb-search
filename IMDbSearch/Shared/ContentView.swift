import SwiftUI

struct ContentView: View {
    @StateObject var manager = SearchManager()

    var body: some View {
        NavigationView {
            VStack {
                Button(
                    action: { manager.search(for: "guardians") },
                    label: { Text("Search!") })
                List {
                    ResultList(manager: manager)
                }
            }
        }
    }
}


struct ResultList: View {
    @ObservedObject var manager: SearchManager

    var body: some View {
        ForEach(manager.results, id: \.result.id) { result in
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


struct TitleDetailView: View {
    @ObservedObject var searchResult: SearchResultWithDetail

    var body: some View {
        List {
            Text(searchResult.result.title)
            Text(searchResult.detail?.year ?? "nil")
        }
        .onAppear {
            searchResult.requestDetail()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
