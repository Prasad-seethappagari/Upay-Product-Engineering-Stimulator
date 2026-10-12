import SwiftUI

@main
struct UPayApp: App {
    private let repository: PaymentRepository
    private let validator: PaymentValidator

    init() {
        let store = InMemoryTransactionStore()
        self.repository = MockPaymentRepository(store: store)
        self.validator = PaymentValidator()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(
                repository: repository,
                validator: validator
            )
        }
    }
}
