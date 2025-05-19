import UIKit

final class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    private let categories = NewsCategory.allCases
    private var selectedCategory: NewsCategory = .general
    private let viewModel = NewsListViewModel(repository: NewsAPIService())

    // MARK: - UI
    private lazy var categorySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: categories.map { $0.displayName })
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        return control
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Новости"
        setupLayout()
        bindViewModel()
        viewModel.fetchNews(for: selectedCategory)
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(categorySegmentedControl)
        view.addSubview(tableView)

        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categorySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] error in
            self?.handle(error: error)
        }
    }

    // MARK: - Actions
    @objc private func categoryChanged(_ sender: UISegmentedControl) {
        selectedCategory = categories[sender.selectedSegmentIndex]
        viewModel.fetchNews(for: selectedCategory)
    }

    // MARK: - Error Handling
    private func handle(error: NetworkError) {
        var message = ""
        switch error {
        case .invalidURL:
            message = "Неверный адрес запроса."
        case .noInternet:
            message = "Нет подключения к интернету."
        case .noData:
            message = "Сервер не вернул данные."
        case .decodingFailed:
            message = "Ошибка обработки данных."
        case .unknown:
            message = "Произошла неизвестная ошибка."
        case .invalidResponse:
            message = "Некорректный ответ от сервера."
        case .other(_):
            message = "Произошла неизвестная ошибка."
        }

        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfArticles()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.article(at: indexPath.row))
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.article(at: indexPath.row)
        let detailVC = NewsDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
