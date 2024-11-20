import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrSearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search Flickr", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.performSearch()
                    }

                // Progress indicator
                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding()
                }

                // Search results
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(viewModel.items, id: \.link) { item in
                            NavigationLink(destination: DetailedView(item: item)) {
                                VStack {
                                    AsyncImage(url: URL(string: item.media.m)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipped()
                                        case .failure:
                                            Color.gray
                                        @unknown default:
                                            Color.gray
                                        }
                                    }
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                }

                if viewModel.items.isEmpty && !viewModel.searchText.isEmpty && !viewModel.isLoading {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}
