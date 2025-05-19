import Foundation

struct NewsResponseDTO: Decodable {
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    let title: String
    let description: String?
    let content: String?
    let author: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let source: SourceDTO

    struct SourceDTO: Decodable {
        let name: String
    }

    func toDomain() -> Article? {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: publishedAt) else {
            return nil
        }

        return Article(
            title: title,
            description: description,
            content: content,
            author: author,
            url: url,
            urlToImage: urlToImage,
            publishedAt: date,
            sourceName: source.name
        )
    }
}
