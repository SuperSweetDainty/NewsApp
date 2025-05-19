import Foundation

final class NewsAPIService: NewsRepository {

    private let session: URLSession
    private let apiKey = "ebdde081af9f40a492b2b925d4e122ba"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTopHeadlines(category: NewsCategory, completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        guard let url = makeURL(for: category) else {
            completion(.failure(.invalidResponse))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.other(urlError)))
                }
                return
            }

            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
            else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let dto = try JSONDecoder().decode(NewsResponseDTO.self, from: data)
                let articles = dto.articles.compactMap { $0.toDomain() }
                completion(.success(articles))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }

        task.resume()
    }

    private func makeURL(for category: NewsCategory) -> URL? {
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")
        components?.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: category.rawValue),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        return components?.url
    }
}
