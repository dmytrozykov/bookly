import SwiftUI

struct StyledRoundedRectangle: View {
    let strokeColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    
    var body: some View {
        rectangle
            .stroke(strokeColor, lineWidth: lineWidth)
            .background(rectangle.fill(backgroundColor))
    }
    
    private var rectangle: some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}
