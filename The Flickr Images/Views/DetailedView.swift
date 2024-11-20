import SwiftUI

struct DetailedView: View {
    let item: FlickrItem

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image
                AsyncImage(url: URL(string: item.media.m)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: .infinity, height: 200)
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(width: .infinity, height: 200)
                    @unknown default:
                        Color.gray
                            .frame(width: .infinity, height: 200)
                    }
                }

                // Title
                Text(item.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                // Description
                HTMLTextView(htmlContent: item.description)
                    .frame(maxWidth: .infinity)
                    .padding()

                // Author
                Text("Author: \(item.author)")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                // Published Date
                Text("Published: \(formatDate(item.published))")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .padding()
        }
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        return outputFormatter.string(from: date)
    }
}
