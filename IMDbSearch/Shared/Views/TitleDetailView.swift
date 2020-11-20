import SwiftUI


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
