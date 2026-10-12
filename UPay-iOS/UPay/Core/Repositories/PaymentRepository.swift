import Foundation

protocol PaymentRepository {
    func makePayment(_ request: PaymentRequest) async throws -> Transaction
    func transactions() async -> [Transaction]
}

actor InMemoryTransactionStore {
    private var items: [Transaction] = []

    func append(_ transaction: Transaction) {
        items.insert(transaction, at: 0)
    }

    func all() -> [Transaction] {
        items
    }
}

enum PaymentRepositoryError: LocalizedError {
    case simulatedNetworkFailure

    var errorDescription: String? {
        switch self {
        case .simulatedNetworkFailure:
            return "The payment service could not complete the request."
        }
    }
}

final class MockPaymentRepository: PaymentRepository {
    private let store: InMemoryTransactionStore

    init(store: InMemoryTransactionStore) {
        self.store = store
    }

    func makePayment(_ request: PaymentRequest) async throws -> Transaction {
        try await Task.sleep(for: .milliseconds(700))

        // Deterministic demo rule: amounts ending in .99 simulate a failure.
        if NSDecimalNumber(decimal: request.amount).doubleValue
            .truncatingRemainder(dividingBy: 1) == 0.99 {
            throw PaymentRepositoryError.simulatedNetworkFailure
        }

        let transaction = Transaction(
            request: request,
            status: .success,
            completedAt: .now
        )

        await store.append(transaction)
        return transaction
    }

    func transactions() async -> [Transaction] {
        await store.all()
    }
}
