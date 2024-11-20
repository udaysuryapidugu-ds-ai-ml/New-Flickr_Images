import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        guard let data = htmlContent.data(using: .utf8) else {
            uiView.text = "Unable to parse HTML content"
            return
        }

        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            uiView.attributedText = attributedString
        } catch {
            uiView.text = "Error parsing HTML content: \(error.localizedDescription)"
        }
    }
}
