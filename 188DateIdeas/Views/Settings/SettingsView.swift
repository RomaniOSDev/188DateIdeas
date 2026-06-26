import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                SectionHeaderView(title: "Settings", subtitle: "Manage your experience")
                    .padding(.bottom, 4)

                SettingsRowCell(icon: "🎯", title: "Retake Preferences Quiz", subtitle: "Update your couple profile") {
                    viewModel.retakeQuiz()
                }

                SettingsRowCell(icon: "⭐", title: "Rate Us", subtitle: "Enjoying the app? Leave a review") {
                    viewModel.rateApp()
                }

                SettingsRowCell(icon: "🔒", title: "Privacy Policy", subtitle: "How we handle your data") {
                    viewModel.openPrivacyPolicy()
                }

                SettingsRowCell(icon: "📄", title: "Terms of Service", subtitle: "Usage terms and conditions") {
                    viewModel.openTerms()
                }

                SettingsRowCell(icon: "ℹ️", title: "Version", subtitle: "2.0 — Couple Edition") {}

                SettingsRowCell(icon: "🗑️", title: "Reset All Data", subtitle: "Deletes everything permanently", isDestructive: true) {
                    viewModel.showResetAlert = true
                }
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Settings", onBack: viewModel.goBack)
        .alert("Reset All Data", isPresented: $viewModel.showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive, action: viewModel.resetAllData)
        } message: {
            Text("All ideas, journal entries, photos, and progress will be deleted.")
        }
    }
}
