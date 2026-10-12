import SwiftUI

struct PayView: View {
    @StateObject private var viewModel: PayViewModel

    init(repository: PaymentRepository, validator: PaymentValidator) {
        _viewModel = StateObject(
            wrappedValue: PayViewModel(
                repository: repository,
                validator: validator
            )
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Payment type") {
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(PaymentType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Payment details") {
                    TextField(
                        viewModel.type == .bill ? "Biller name" : "UPI ID",
                        text: $viewModel.payee
                    )
                    .textInputAutocapitalization(.never)

                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)

                    if viewModel.type == .bill {
                        TextField("Bill reference", text: $viewModel.reference)
                    }

                    TextField("Note (optional)", text: $viewModel.note)
                }

                Section {
                    Button {
                        viewModel.submit()
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isProcessing {
                                ProgressView()
                            } else {
                                Text("Pay securely")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(viewModel.isProcessing)
                }

                Section("Demo") {
                    NavigationLink("Generate a QR code") {
                        QRView()
                    }
                }
            }
            .navigationTitle("UPay")
            .alert(
                "Payment",
                isPresented: Binding(
                    get: { viewModel.alertMessage != nil },
                    set: { if !$0 { viewModel.alertMessage = nil } }
                )
            ) {
                Button("OK") { viewModel.alertMessage = nil }
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
            .sheet(item: $viewModel.completedTransaction) { transaction in
                PaymentSuccessView(transaction: transaction)
            }
        }
    }
}
