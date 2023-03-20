
import Foundation

struct Article: Decodable {
    var articles: [Articles]
}

struct Articles: Decodable {
    var description: String?
    var urlToImage: String?
    var url: String?
    var publishedAt: String?
}
