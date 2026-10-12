import Foundation

enum PaymentType: String, CaseIterable, Codable, Identifiable {
    case p2p = "P2P"
    case merchant = "Merchant"
    case qr = "QR"
    case bill = "Bill"

    var id: String { rawValue }
}

enum TransactionStatus: String, Codable {
    case pending
    case success
    case failed
}

struct PaymentRequest: Identifiable, Codable {
    let id: UUID
    let type: PaymentType
    let payee: String
    let amount: Decimal
    let note: String
    let reference: String?
    let createdAt: Date

    init(
        id: UUID = UUID(),
        type: PaymentType,
        payee: String,
        amount: Decimal,
        note: String = "",
        reference: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.type = type
        self.payee = payee
        self.amount = amount
        self.note = note
        self.reference = reference
        self.createdAt = createdAt
    }
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    let request: PaymentRequest
    let status: TransactionStatus
    let completedAt: Date?
    let failureReason: String?

    init(
        id: UUID = UUID(),
        request: PaymentRequest,
        status: TransactionStatus,
        completedAt: Date? = nil,
        failureReason: String? = nil
    ) {
        self.id = id
        self.request = request
        self.status = status
        self.completedAt = completedAt
        self.failureReason = failureReason
    }
}
