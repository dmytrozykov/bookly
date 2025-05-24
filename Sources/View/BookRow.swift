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
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            
            Text(book.author)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var progress: some View {
        let progress = book.pageCount == 0 || book.currentPage == 0 ?
        0 :
        Double(book.currentPage) / Double(book.pageCount)
        
        return ZStack {
            CircularProgressBar(
                progress: progress,
                lineWidth: 8
            )
            
            Text("\(progress * 100, specifier: "%.0f")")
                .font(.system(size: 10))
                .bold()
        }
        .frame(width: 32, height: 32)
    }
}

#Preview {
    BookRow(book: .preview)
        .padding()
}
