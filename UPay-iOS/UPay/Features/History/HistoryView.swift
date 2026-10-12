import SwiftUI

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []
    private let repository: PaymentRepository

    init(repository: PaymentRepository) {
        self.repository = repository
    }

    func load() async {
        transactions = await repository.transactions()
    }
}

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel

    init(repository: PaymentRepository) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.transactions.isEmpty {
                    ContentUnavailableView(
                        "No transactions",
                        systemImage: "tray",
                        description: Text("Your demo payments will appear here.")
                    )
                } else {
                    List(viewModel.transactions) { transaction in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(transaction.request.payee)
                                    .font(.headline)
                                Spacer()
                                Text(transaction.status.rawValue.capitalized)
                                    .foregroundStyle(
                                        transaction.status == .success ? .green : .red
                                    )
                            }

                            Text("₹\(NSDecimalNumber(decimal: transaction.request.amount).stringValue)")
                                .font(.subheadline)

                            Text(transaction.request.type.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .task {
                await viewModel.load()
            }
        }
    }
}
