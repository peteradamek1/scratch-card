import SwiftUI

struct ScratchView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: ScratchViewModel
    
    // MARK: - Stored properties
    
    private let onScratchCodeRevealed: (ScratchCode) -> Void
    
    // MARK: - Initialization
    
    init(onScratchCodeRevealed: @escaping (ScratchCode) -> Void, dependencyContainer: ScratchDependencyContainer) {
        _viewModel = StateObject(wrappedValue: dependencyContainer.makeViewModel())
        self.onScratchCodeRevealed = onScratchCodeRevealed
    }
    
    // MARK: - View
    
    var body: some View {
        content
            .navigationTitle("scratchScreen.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.scratchCode) { _, newValue in
                guard let newValue else { return }
                onScratchCodeRevealed(newValue)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            revealCodeButton
        case .loading:
            ProgressView()
        case .error(let messageKey):
            Text(LocalizedStringKey(messageKey))
            revealCodeButton
        }
    }
    
    private var revealCodeButton: some View {
        Button("scratchScreen.scratchButton", action: { viewModel.didTapRevealCodeButton() })
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
    }
}

#Preview {
    ScratchView(
        onScratchCodeRevealed: { _ in },
        dependencyContainer: AppDependencyContainer().makeMainDependencyContainer().makeScratchDependencyContainer()
    )
}
