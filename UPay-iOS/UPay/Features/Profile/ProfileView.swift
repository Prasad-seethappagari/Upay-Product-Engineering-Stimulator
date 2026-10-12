import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Developer demo") {
                    LabeledContent("Architecture", value: "MVVM")
                    LabeledContent("State", value: "Combine")
                    LabeledContent("Data", value: "Repository")
                    LabeledContent("Payments", value: "Simulated")
                }

                Section("Safety") {
                    Text("No real bank account, UPI credential, or money movement is used.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
