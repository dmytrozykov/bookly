import ComposableArchitecture
import Foundation

@Reducer
public struct AddBookFeature {
    @ObservableState
    public struct State: Equatable {
        var book: BookModel
    }
    
    public enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setTitle(String)
        case setAuthor(String)
        case setIsbn(String)
        case setPageCount(Int)
        case delegate(Delegate)
        
        @CasePathable
        public enum Delegate: Equatable {
            case saveBook(BookModel)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .saveButtonTapped:
                return .run { [book = state.book] send in
                    await send(.delegate(.saveBook(book)))
                    await self.dismiss()
                }
                
            case let .setTitle(title):
                state.book.title = title
                return .none
                
            case let .setAuthor(author):
                state.book.author = author
                return .none
                
            case let .setIsbn(isbn):
                state.book.isbn = isbn
                return .none
                
            case let .setPageCount(pageCount):
                state.book.pageCount = pageCount
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
