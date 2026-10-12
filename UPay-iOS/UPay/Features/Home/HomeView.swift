import SwiftUI

struct HomeView: View {
    let repository: PaymentRepository
    let validator: PaymentValidator

    var body: some View {
        TabView {
            PayView(repository: repository, validator: validator)
                .tabItem {
                    Label("Pay", systemImage: "indianrupeesign.circle")
                }

            HistoryView(repository: repository)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
