import Foundation

struct PaymentValidationResult {
    let isValid: Bool
    let message: String?
}

struct PaymentValidator {
    private let maxAmount = Decimal(100_000)

    func validate(
        type: PaymentType,
        payee: String,
        amount: Decimal,
        note: String,
        reference: String?
    ) -> PaymentValidationResult {
        let trimmedPayee = payee.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPayee.isEmpty else {
            return .init(isValid: false, message: "Enter a payee.")
        }

        guard amount > 0 else {
            return .init(isValid: false, message: "Amount must be greater than ₹0.")
        }

        guard amount <= maxAmount else {
            return .init(isValid: false, message: "Demo limit is ₹100,000.")
        }

        guard note.count <= 80 else {
            return .init(isValid: false, message: "Note must be 80 characters or fewer.")
        }

        if type == .p2p || type == .merchant {
            guard trimmedPayee.contains("@") else {
                return .init(isValid: false, message: "Enter a valid demo UPI ID.")
            }
        }

        if type == .bill {
            guard !(reference ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .init(isValid: false, message: "Enter a bill reference.")
            }
        }

        return .init(isValid: true, message: nil)
    }
}
