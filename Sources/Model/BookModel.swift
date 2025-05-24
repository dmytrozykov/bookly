import CoreData

struct BookModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let author: String
    let isbn: String
    let pageCount: Int
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

extension Book {
    var bookModel: BookModel {
        .init(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            author: self.author ?? "",
            isbn: self.isbn ?? "",
            pageCount: Int(self.pageCount),
            currentPage: Int(self.currentPage)
        )
    }
}
