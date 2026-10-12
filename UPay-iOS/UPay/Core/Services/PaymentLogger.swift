import Foundation
import os

enum PaymentLogger {
    private static let logger = Logger(
        subsystem: "com.example.UPay",
        category: "PaymentFlow"
    )

    static func validationFailed(_ message: String) {
        logger.warning("Payment validation failed: \(message, privacy: .public)")
    }

    static func started(type: PaymentType, transactionID: UUID) {
        logger.info("Payment started. type=\(type.rawValue, privacy: .public) id=\(transactionID.uuidString, privacy: .public)")
    }

    static func completed(transactionID: UUID) {
        logger.info("Payment completed. id=\(transactionID.uuidString, privacy: .public)")
    }

    static func failed(_ error: Error) {
        logger.error("Payment failed: \(error.localizedDescription, privacy: .public)")
    }
}
