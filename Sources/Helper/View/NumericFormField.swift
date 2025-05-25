import SwiftUI

struct NumericFormField: View {
    let image: Image?
    let label: LocalizedStringKey
    let value: Binding<Int>
    let required: Bool
    
    init(
        image: Image? = nil,
        label: LocalizedStringKey,
        value: Binding<Int>,
        required: Bool = false
    ) {
        self.image = image
        self.label = label
        self.value = value
        self.required = required
    }
    
    private var stringBinding: Binding<String> {
        Binding(
            get: { value.wrappedValue == 0 ? "" : String(value.wrappedValue) },
            set: { newValue in
                if let intValue = Int(newValue), intValue >= 0 {
                    value.wrappedValue = intValue
                } else if newValue.isEmpty {
                    value.wrappedValue = 0
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            fieldHeader
            numericTextField
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
    
    private var numericTextField: some View {
        TextField("0", text: stringBinding)
            .keyboardType(.numberPad)
            .padding(12)
            .background(
                .secondary.opacity(0.05),
                in: .rect(cornerRadius: 8)
            )
    }
}

#Preview {
    NumericFormField(
        image: Image(systemName: "number"),
        label: "Total pages",
        value: .constant(0),
        required: false
    )
}
