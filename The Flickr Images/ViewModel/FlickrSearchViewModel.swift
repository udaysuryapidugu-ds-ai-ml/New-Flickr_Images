import Foundation
import Combine

class FlickrSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var items: [FlickrItem] = []
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    func performSearch() {
        guard !searchText.isEmpty else {
            items = []
            return
        }

        let tags = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else { return }

        isLoading = true
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlickrFeed.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.items = []
                }
            }, receiveValue: { [weak self] feed in
                self?.items = feed.items
            })
            .store(in: &cancellables)
    }
}
