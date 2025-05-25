import CoreData

public struct BookModel: Identifiable, Hashable {
    public let id: UUID
    var title: String
    var author: String
    var isbn: String
    var pageCount: Int
    var currentPage: Int
    
    static let preview: BookModel = .init(
        id: UUID(),
        title: "The Alchemist",
        author: "Paulo Coelho",
        isbn: "9780062564811",
        pageCount: 224,
        currentPage: 12
    )
}

extension BookModel {
    init(from bookEntity: Book) {
        self.init(
            id: bookEntity.id ?? UUID(),
            title: bookEntity.title ?? "",
            author: bookEntity.author ?? "",
            isbn: bookEntity.isbn ?? "",
            pageCount: Int(bookEntity.pageCount),
            currentPage: Int(bookEntity.currentPage)
        )
    }
    
    init(id: UUID = UUID()) {
        self.init(
            id: id,
            title: "",
            author: "",
            isbn: "",
            pageCount: 0,
            currentPage: 0
        )
    }
}
