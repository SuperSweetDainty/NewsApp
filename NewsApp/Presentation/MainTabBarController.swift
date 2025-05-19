import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground() 
            appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        let newsListVC = NewsListViewController()
        newsListVC.title = "Новости"
        newsListVC.tabBarItem = UITabBarItem(
            title: "Новости",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )

        let bookmarksVC = BookmarksViewController()
        bookmarksVC.title = "Закладки"
        bookmarksVC.tabBarItem = UITabBarItem(
            title: "Закладки",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )

        viewControllers = [
            UINavigationController(rootViewController: newsListVC),
            UINavigationController(rootViewController: bookmarksVC)
        ]

        tabBar.tintColor = .systemBlue
    }
}
