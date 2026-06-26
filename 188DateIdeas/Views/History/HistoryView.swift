import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    PillChipView(title: "All", isSelected: viewModel.ratingFilter == nil) {
                        viewModel.ratingFilter = nil
                    }
                    ForEach(1...5, id: \.self) { rating in
                        PillChipView(
                            title: String(repeating: "⭐", count: rating),
                            isSelected: viewModel.ratingFilter == rating
                        ) {
                            viewModel.ratingFilter = viewModel.ratingFilter == rating ? nil : rating
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 12)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredHistory) { entry in
                        JournalCell(
                            entry: entry,
                            photo: viewModel.thumbnail(for: entry),
                            onTap: { viewModel.openJournal(entry) },
                            onRating: { viewModel.updateRating(for: entry, rating: $0) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .overlay {
                if viewModel.filteredHistory.isEmpty {
                    EmptyStateView(
                        icon: "📔",
                        title: "No Journal Entries",
                        message: "Complete a date and write a reflection",
                        buttonTitle: "Go Back",
                        action: viewModel.goBack
                    )
                }
            }
        }
        .appScreenBackground()
        .appNavigationBar(title: "Journal", onBack: viewModel.goBack)
        .onAppear { viewModel.loadHistory() }
    }
}
