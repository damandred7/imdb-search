import SwiftUI


struct ContentView: View {
    @StateObject var manager = SearchManager()

    var body: some View {
        NavigationView {
            VStack {
                Button(
                    action: { manager.search(for: "guardians") },
                    label: { Text("Search!") })
                ResultList(manager: manager)
            }
            .navigationTitle("Search for a movie")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
