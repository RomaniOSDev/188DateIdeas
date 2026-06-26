import SwiftUI

struct IdeaListView: View {
    @ObservedObject var viewModel: IdeaListViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                AppSearchField(text: $viewModel.searchText, placeholder: "Search ideas...")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        if viewModel.microOnly {
                            PillChipView(title: "⚡ Micro-Dates", isSelected: true) {}
                        }
                        if viewModel.personalizedOnly {
                            PillChipView(title: "✨ For You", isSelected: true) {}
                        }
                        if let tag = viewModel.seasonTag {
                            PillChipView(title: "\(tag.icon) \(tag.label)", isSelected: true) {}
                        }
                        PillChipView(title: "❤️ Favorites", isSelected: viewModel.showFavoritesOnly) {
                            viewModel.showFavoritesOnly.toggle()
                        }
                        ForEach(Category.allCases, id: \.self) { category in
                            PillChipView(
                                title: "\(category.icon) \(category.rawValue)",
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredIdeas) { idea in
                        IdeaCell(
                            idea: idea,
                            onTap: { viewModel.goToIdeaDetail(idea) },
                            onFavorite: { viewModel.toggleFavorite(idea) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .overlay {
                if viewModel.filteredIdeas.isEmpty {
                    EmptyStateView(
                        icon: "💡",
                        title: "No Ideas Found",
                        message: "Try a different filter or add a new idea",
                        buttonTitle: "Add Idea",
                        action: viewModel.goToIdeaForm
                    )
                }
            }
        }
        .appScreenBackground()
        .appNavigationBar(title: listTitle, onBack: viewModel.goBack)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.goToIdeaForm) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppDesign.accentGradient)
                }
            }
        }
        .onAppear { viewModel.loadIdeas() }
    }

    private var listTitle: String {
        if viewModel.microOnly { return "Micro-Dates" }
        if viewModel.personalizedOnly { return "For You" }
        return "Ideas"
    }
}
