import ComposableArchitecture
import SwiftUI

struct AddBookView: View {
    @ComposableArchitecture.Bindable
    var store: StoreOf<AddBookFeature>
    
    private var canSave: Bool {
        !store.book.title.isEmpty &&
        !store.book.author.isEmpty &&
        store.book.pageCount > 0
    }
    
    var body: some View {
        contentView
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
    }
    
    private var contentView: some View {
        VStack {
            Divider()
            bookCoverSection
            Divider()
            formSection
            Spacer()
            requiredFieldsNote
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", systemImage: "xmark") {
                store.send(.cancelButtonTapped)
            }
        }
        
        ToolbarItem(placement: .primaryAction) {
            Button("Save") {
                store.send(.saveButtonTapped)
            }
            .disabled(!canSave)
        }
    }
    
    private var bookCoverSection: some View {
        VStack(spacing: 12) {
            coverImageView
            coverInstructionText
        }
        .padding()
    }
    
    private var coverImageView: some View {
        ZStack {
            BookCoverImage()
                .frame(width: 90, height: 120)
            
            Image(systemName: "camera")
                .font(.system(size: 32))
                .foregroundStyle(Color(.systemBackground).opacity(0.7))
        }
    }
    
    private var coverInstructionText: some View {
        Text("Tap to add cover photo")
            .font(.headline)
            .foregroundStyle(.secondary)
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            titleField
            authorField
            pageFields
        }
        .padding()
    }
    
    private var titleField: some View {
        FormField(
            image: Image(systemName: "book"),
            label: "Title",
            prompt: "Enter book title",
            text: $store.book.title.sending(\.setTitle),
            required: true
        )
    }
    
    private var authorField: some View {
        FormField(
            image: Image(systemName: "person"),
            label: "Author",
            prompt: "Enter author name",
            text: $store.book.author.sending(\.setAuthor),
            required: true
        )
    }
    
    private var pageFields: some View {
        HStack(spacing: 16) {
            totalPagesField
            currentPageField
        }
    }
    
    private var totalPagesField: some View {
        NumericFormField(
            image: Image(systemName: "number"),
            label: "Total pages",
            value: $store.book.pageCount.sending(\.setPageCount),
            required: true
        )
    }
    
    private var currentPageField: some View {
        NumericFormField(
            label: "Current page",
            // TODO: Add ability to set current page
            value: .constant(0)
        )
    }
    
    private var requiredFieldsNote: some View {
        Text("* Required fields")
            .font(.footnote)
            .foregroundStyle(.secondary)
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
