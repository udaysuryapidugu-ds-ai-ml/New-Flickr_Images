import Foundation

struct FlickrFeed: Codable {
    let items: [FlickrItem]
}

struct FlickrItem: Codable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorID: String
    let tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media, description, published, author, tags
        case dateTaken = "date_taken"
        case authorID = "author_id"
    }
}

struct Media: Codable {
    let m: String
}
