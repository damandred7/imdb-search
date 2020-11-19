import SwiftUI

struct ContentView: View {
    @StateObject var manager = SearchManager()

    var body: some View {
        VStack {
            Button(
                action: {
                    manager.search(for: "guardians")
                },
                label: {
                    Text("Search!")
                })
            .padding()
            List {
                ResultList(results: $manager.results)
            }
        }
    }
}


struct ResultList: View {
    @Binding var results: [SearchResult]

    var body: some View {
        ForEach(results, id: \.id) { result in
            Text(result.title)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
