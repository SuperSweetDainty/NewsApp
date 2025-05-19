import Foundation
import CoreData

protocol BookmarksRepository {
    func isBookmarked(article: Article) -> Bool
    func save(article: Article)
    func remove(article: Article)
    func getAll() -> [Article]
}

final class CoreDataBookmarksRepository: BookmarksRepository {

    private let context = CoreDataStack.shared.context

    func isBookmarked(article: Article) -> Bool {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", article.url)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func save(article: Article) {
        guard !isBookmarked(article: article) else { return }

        let entity = BookmarkEntity(context: context)
        entity.title = article.title
        entity.author = article.author
        entity.sourceName = article.sourceName
        entity.publishedAt = article.publishedAt
        entity.content = article.content
        entity.url = article.url
        entity.urlToImage = article.urlToImage
        entity.descriptionText = article.description

        CoreDataStack.shared.saveContext()
    }


    func remove(article: Article) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", article.url)

        if let result = try? context.fetch(request), let objectToDelete = result.first {
            context.delete(objectToDelete)
            CoreDataStack.shared.saveContext()
        }
    }

    func getAll() -> [Article] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        let entities = (try? context.fetch(request)) ?? []

        return entities.map { entity in
            Article(
                title: entity.title ?? "",
                description: entity.descriptionText,
                content: entity.content,
                author: entity.author,
                url: entity.url ?? "",
                urlToImage: entity.urlToImage,
                publishedAt: entity.publishedAt ?? Date(),
                sourceName: entity.sourceName ?? ""
            )
        }
    }
}
