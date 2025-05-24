import SwiftUI

struct BookDetail: View {
    @State var book: BookModel
    let onSave: (BookModel) -> Void
    
    @State private var draft: BookModel
    @State private var isEditing = false
    
    init(
        book: BookModel,
        onSave: @escaping (BookModel) -> Void
    ) {
        self._book = State(initialValue: book)
        self.onSave = onSave
        self._draft = State(initialValue: book)
    }
    
    var body: some View {
        Form {
            infoSection
            pageCounter
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        draft = book
                        isEditing = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        book = draft
                        onSave(book)
                        isEditing = false
                    }
                    .disabled(draft == book)
                }
            } else {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
        }
    }
    
    private var infoSection: some View {
        Section(header: Text("Book Info")) {
            if isEditing {
                TextField("Title", text: $draft.title)
                TextField("Author", text: $draft.author)
                TextField("Page Count", value: $draft.pageCount, formatter: NumberFormatter())
                TextField("ISBN", text: $draft.isbn)
                    .keyboardType(.numberPad)
            } else {
                LabeledContent("Title", value: book.title)
                LabeledContent("Author", value: book.author)
                LabeledContent("Page Count", value: "\(book.pageCount)")
                LabeledContent("ISBN", value: book.isbn)
            }
        }
    }
    
    private var pageCounter: some View {
        Section(header: Text("Progress")) {
            if isEditing {
                Stepper(value: $draft.currentPage, in: 0...draft.pageCount, step: 1) {
                    Text("Pages Read: \(draft.currentPage) / \(draft.pageCount)")
                }
            } else {
                LabeledContent("Pages Read", value: "\(book.currentPage) / \(book.pageCount)")
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var book = BookModel.preview
        
        var body: some View {
            NavigationStack {
                BookDetail(book: book) { updatedBook in
                    book = updatedBook
                }
            }
        }
    }
    
    return PreviewWrapper()
}
