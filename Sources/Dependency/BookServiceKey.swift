import ComposableArchitecture

private enum BookServiceKey: DependencyKey {
    static let liveValue: BookServiceProtocol = BookService()
}

extension DependencyValues {
    var bookService: BookServiceProtocol {
        get {
            self[BookServiceKey.self]
        } set {
            self[BookServiceKey.self] = newValue
        }
    }
}
