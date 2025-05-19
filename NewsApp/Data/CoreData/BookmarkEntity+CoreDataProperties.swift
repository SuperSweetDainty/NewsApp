import Foundation
import CoreData


extension BookmarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var author: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var content: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension BookmarkEntity : Identifiable {

}
