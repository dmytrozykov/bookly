import SwiftUI

struct BookRow: View {
    let book: BookModel
    
    private var progressPercentage: Double {
        guard book.pageCount > 0, book.currentPage > 0 else { return 0 }
        return Double(book.currentPage) / Double(book.pageCount)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            bookCoverImage
            bookContent
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(16)
        .background(cardBackground)
    }
    
    private var bookContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleSection
            progressSection
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.title3)
                .bold()
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text("by \(book.author)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 8) {
            progressHeader
            progressBar
            progressFooter
        }
    }
    
    private var progressHeader: some View {
        HStack {
            Text("Progress")
            Spacer()
            Text("\(Int(progressPercentage * 100))%")
        }
        .font(.footnote)
        .bold()
    }
    
    private var progressBar: some View {
        ProgressView(value: progressPercentage)
            .frame(height: 8)
            .scaleEffect(x: 1, y: 2, anchor: .center)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    private var progressFooter: some View {
        HStack {
            progressStatusText
            Spacer()
            continueButton
        }
    }
    
    private var progressStatusText: some View {
        Text(statusText)
            .font(.footnote)
            .bold()
            .foregroundColor(statusColor)
    }
    
    private var continueButton: some View {
        Button("Continue") {}
            .foregroundColor(.accentColor)
            .font(.subheadline)
            .bold()
            .buttonStyle(.plain)
    }
    
    private var bookCoverImage: some View {
        BookCoverImage()
            .frame(width: 60, height: 80)
    }
    
    private var cardBackground: some View {
        StyledRoundedRectangle(
            strokeColor: Color(.label).opacity(0.1),
            backgroundColor: Color(.systemBackground),
            cornerRadius: 24,
            lineWidth: 1
        )
        .shadow(
            color: Color(.label).opacity(0.05),
            radius: 5,
            x: 3,
            y: 3
        )
    }
    
    private var statusText: String {
        switch progressPercentage {
        case 0: return "Not Started"
        case 0..<0.5: return "Just Started"
        case 0.5..<1: return "In Progress"
        default: return "Completed"
        }
    }
    
    private var statusColor: Color {
        switch progressPercentage {
        case 0, 0..<0.5: return .secondary
        case 0.5..<1: return .accentColor
        default: return .green
        }
    }
}

#Preview {
    BookRow(book: .preview)
        .padding()
}
