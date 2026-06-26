import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if coordinator.showIntroOnboarding {
                IntroOnboardingView(viewModel: IntroOnboardingViewModel(storageService: coordinator.storageService) {
                    coordinator.completeIntroOnboarding()
                    coordinator.homeViewModel.reload()
                })
            } else if coordinator.showPreferencesQuiz {
                PreferencesQuizView(viewModel: PreferencesQuizViewModel(storageService: coordinator.storageService) {
                    coordinator.completePreferencesQuiz()
                    coordinator.homeViewModel.reload()
                })
            } else {
                NavigationStack(path: $coordinator.path) {
                    HomeView(viewModel: coordinator.homeViewModel)
                        .navigationDestination(for: AppDestination.self) { destination in
                            coordinator.view(for: destination)
                        }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
