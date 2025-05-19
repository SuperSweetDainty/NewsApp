import Foundation

protocol NewsRepository {
    func fetchTopHeadlines(category: NewsCategory, completion: @escaping (Result<[Article], NetworkError>) -> Void)
}
