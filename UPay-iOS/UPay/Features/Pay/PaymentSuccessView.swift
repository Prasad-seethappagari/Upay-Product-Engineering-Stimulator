import SwiftUI

struct PaymentSuccessView: View {
    let transaction: Transaction
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .accessibilityLabel("Payment successful")

            Text("Payment successful")
                .font(.title2.bold())

            Text("₹\(NSDecimalNumber(decimal: transaction.request.amount).stringValue)")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text("To: \(transaction.request.payee)")
                Text("Type: \(transaction.request.type.rawValue)")
                Text("ID: \(transaction.id.uuidString.prefix(8))…")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
