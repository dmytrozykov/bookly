import SwiftUI

struct FormField: View {
    let image: Image?
    let label: LocalizedStringKey
    let prompt: LocalizedStringKey
    let text: Binding<String>
    let required: Bool
    
    init(
        image: Image? = nil,
        label: LocalizedStringKey,
        prompt: LocalizedStringKey = "",
        text: Binding<String>,
        required: Bool = false
    ) {
        self.image = image
        self.label = label
        self.prompt = prompt
        self.text = text
        self.required = required
    }
    
    var body: some View {
        VStack {
            fieldHeader
            textField
        }
    }
    
    private var fieldHeader: some View {
        HStack {
            if let image {
                image
            }
            labelWithRequiredIndicator
            Spacer()
        }
        .font(.subheadline)
    }
    
    private var labelWithRequiredIndicator: some View {
        HStack(spacing: 4) {
            Text(label)
            if required {
                Text("*")
            }
        }
    }
    
    private var textField: some View {
        TextField(text: text) {
            Text(prompt)
        }
        .padding(12)
        .background(
            .secondary.opacity(0.05),
            in: .rect(cornerRadius: 8)
        )
    }
}

#Preview {
    FormField(
        image: Image(systemName: "person"),
        label: "Name",
        prompt: "Enter your name",
        text: .constant(""),
        required: false
    )
}
