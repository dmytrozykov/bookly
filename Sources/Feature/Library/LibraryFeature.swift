import ComposableArchitecture
import Foundation

@Reducer
public struct LibraryFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        
        var books: [BookModel] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    public enum Action {
        case onAppear
        case refresh
        
        case booksLoaded([BookModel])
        
        case loadingError(String)
        case savingError(String)
        
        case addButtonTapped
        case deleteButtonTapped(id: BookModel.ID)
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.bookService) var bookService
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                state.isLoading = true
                return .run { send in
                    do {
                        let books = try await bookService.fetchBooks()
                        await send(.booksLoaded(books))
                    } catch {
                        await send(.loadingError(error.localizedDescription))
                    }
                }
                
            case let .booksLoaded(books):
                state.isLoading = false
                state.books = books
                state.errorMessage = nil
                return .none
                
            case let .loadingError(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            case let .savingError(message):
                state.errorMessage = message
                return .none
                
            case .addButtonTapped:
                state.destination = .addBook(
                    AddBookFeature.State(book: BookModel())
                )
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
                
            case let .destination(.presented(.addBook(.delegate(.saveBook(book))))):
                return .run { send in
                    do {
                        _ = try await bookService.addBook(book)
                        await send(.refresh)
                    } catch {
                        await send(.savingError(error.localizedDescription))
                    }
                }
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                return .run { send in
                    do {
                        try await bookService.deleteBook(with: id)
                        await send(.refresh)
                    } catch {
                        await send(.savingError(error.localizedDescription))
                    }
                }
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
    }
}

extension LibraryFeature.Action {
    @CasePathable
    public enum Alert: Equatable {
        case confirmDeletion(id: BookModel.ID)
    }
}

extension LibraryFeature {
    @Reducer
    public enum Destination {
        case addBook(AddBookFeature)
        case alert(AlertState<LibraryFeature.Action.Alert>)
    }
}

extension LibraryFeature.Destination.State: Equatable {}
