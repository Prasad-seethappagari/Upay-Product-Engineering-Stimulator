import SwiftUI

struct QRView: View {
    @State private var payload = "upi://pay?pa=demo@upi&pn=UPay%20Demo&am=100"

    var body: some View {
        VStack(spacing: 20) {
            Text("Demo merchant QR")
                .font(.title2.bold())

            if let image = QRCodeGenerator.makeImage(from: payload) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .accessibilityLabel("Demo payment QR code")
            }

            Text(payload)
                .font(.caption)
                .multilineTextAlignment(.center)
                .textSelection(.enabled)

            Text("This QR is for the portfolio simulator only.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("QR")
    }
}
