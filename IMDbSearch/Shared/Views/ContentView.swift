import SwiftUI


struct ContentView: View {
    @StateObject var manager = SearchManager()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Search for a movie...", text: $manager.searchText)
                    .padding()
                ResultList(manager: manager)
            }
            .navigationTitle("IMDB Movie Search")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
