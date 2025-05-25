import ComposableArchitecture
import SwiftUI

struct AddBookView: View {
    @ComposableArchitecture.Bindable
    var store: StoreOf<AddBookFeature>
    
    var body: some View {
        Form {
            LabeledContent {
                TextField("", text: $store.book.title.sending(\.setTitle))
            } label: {
                Text("Title")
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $store.book.author.sending(\.setAuthor))
            } label: {
                Text("Author")
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $store.book.isbn.sending(\.setIsbn))
                    .keyboardType(.numberPad)
            } label: {
                Text("ISBN")
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", value: $store.book.pageCount.sending(\.setPageCount), formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            } label: {
                Text("Page Count")
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    store.send(.saveButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddBookView(
            store: Store(
                initialState: AddBookFeature.State(
                    book: BookModel()
                )
            ) {
                AddBookFeature()
            }
        )
    }
}
