import SwiftUI

struct BookCoverImage: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(gradientColors)
    }
    
    private var gradientColors: LinearGradient {
        let baseHue = Double.random(in: 0...1)
        let offsetHue = (baseHue + Double.random(in: 0.05...0.2))
            .truncatingRemainder(dividingBy: 1)
        
        let color1 = Color(hue: baseHue, saturation: 0.7, brightness: 0.9)
        let color2 = Color(hue: offsetHue, saturation: 0.7, brightness: 0.9)
        
        return LinearGradient(
            colors: [color1, color2],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    BookCoverImage()
}
