import Foundation

final class NewsListViewModel {

    // MARK: - Properties
    private let repository: NewsRepository
    private(set) var articles: [Article] = []

    var onDataUpdated: (() -> Void)?
    var onError: ((NetworkError) -> Void)?

    // MARK: - Init
    init(repository: NewsRepository) {
        self.repository = repository
    }

    // MARK: - Public Methods
    func fetchNews(for category: NewsCategory) {
        repository.fetchTopHeadlines(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.onDataUpdated?()
                case .failure(let error):
                    print("Не удалось получить новости: \(error)")
                    self?.onError?(error)
                }
            }
        }
    }

    func article(at index: Int) -> Article {
        articles[index]
    }

    func numberOfArticles() -> Int {
        articles.count
    }
}
