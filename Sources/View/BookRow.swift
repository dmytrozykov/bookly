import SwiftUI

struct BookRow: View {
    let book: BookModel
    
    var body: some View {
        HStack {
            title
            
            Spacer()
            
            progress
        }
    }
    
    private var title: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
            
            Text(book.author)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var progress: some View {
        let isFinished = book.currentPage == book.pageCount
        
        return HStack {
            Text("\(book.currentPage)")
                .foregroundStyle(
                    isFinished ? .primary : .secondary
                )
            Text("/")
            Text("\(book.pageCount)")
        }
        .font(.title3)
    }
}

#Preview {
    BookRow(book: .preview)
        .padding()
}
