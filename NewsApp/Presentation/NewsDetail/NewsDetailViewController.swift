import UIKit

final class NewsDetailViewController: UIViewController {

    private let article: Article
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let sourceLabel = UILabel()
    private let contentLabel = UILabel()
    private let bookmarkButton = UIButton(type: .system)
    private let bookmarksRepository = CoreDataBookmarksRepository()

    private var isBookmarked = false

    // MARK: - Init
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        configure(with: article)
        isBookmarked = bookmarksRepository.isBookmarked(article: article)
        updateBookmarkButton()
    }

    // MARK: - Setup
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        [imageView, titleLabel, authorLabel, sourceLabel, dateLabel, contentLabel, bookmarkButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview($0)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0

        authorLabel.font = .systemFont(ofSize: 16)
        sourceLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel

        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 16)

        bookmarkButton.setTitle("Добавить в закладки", for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    // MARK: - Configure
    private func configure(with article: Article) {
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            imageView.isHidden = true
        }

        titleLabel.text = article.title
        authorLabel.text = "Автор: \(article.author ?? "неизвестен")"
        sourceLabel.text = "Источник: \(article.sourceName)"

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = "Дата: \(formatter.string(from: article.publishedAt))"

        contentLabel.text = article.content ?? "Нет полного текста."
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func bookmarkTapped() {
        if isBookmarked {
            bookmarksRepository.remove(article: article)
        } else {
            bookmarksRepository.save(article: article)
        }
        isBookmarked.toggle()
        updateBookmarkButton()
    }

    private func updateBookmarkButton() {
        let title = isBookmarked ? "Удалить из закладок" : "Добавить в закладки"
        bookmarkButton.setTitle(title, for: .normal)
    }
}
