import Foundation
import Combine

@MainActor
final class PayViewModel: ObservableObject {
    @Published var type: PaymentType = .p2p
    @Published var payee = ""
    @Published var amount = ""
    @Published var note = ""
    @Published var reference = ""
    @Published var isProcessing = false
    @Published var alertMessage: String?
    @Published var completedTransaction: Transaction?

    private let repository: PaymentRepository
    private let validator: PaymentValidator

    init(repository: PaymentRepository, validator: PaymentValidator) {
        self.repository = repository
        self.validator = validator
    }

    func submit() {
        guard let decimalAmount = Decimal(string: amount) else {
            alertMessage = "Enter a valid amount."
            return
        }

        let validation = validator.validate(
            type: type,
            payee: payee,
            amount: decimalAmount,
            note: note,
            reference: type == .bill ? reference : nil
        )

        guard validation.isValid else {
            let message = validation.message ?? "Invalid payment details."
            PaymentLogger.validationFailed(message)
            alertMessage = message
            return
        }

        let request = PaymentRequest(
            type: type,
            payee: payee.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: decimalAmount,
            note: note,
            reference: type == .bill ? reference : nil
        )

        isProcessing = true
        PaymentLogger.started(type: type, transactionID: request.id)

        Task {
            do {
                let transaction = try await repository.makePayment(request)
                completedTransaction = transaction
                isProcessing = false
                PaymentLogger.completed(transactionID: transaction.id)
                clearForm()
            } catch {
                isProcessing = false
                PaymentLogger.failed(error)
                alertMessage = error.localizedDescription
            }
        }
    }

    private func clearForm() {
        payee = ""
        amount = ""
        note = ""
        reference = ""
    }
}
