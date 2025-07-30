import SwiftUI

struct ActivationView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: ActivationViewModel
    
    // MARK: - Initialization
    
    init(scratchCode: ScratchCode, dependencyContainer: ActivationDependencyContainer) {
        _viewModel = StateObject(wrappedValue: dependencyContainer.makeViewModel(scratchCode: scratchCode))
    }

    // MARK: - View

    var body: some View {
        content
            .navigationTitle("activationScreen.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("common.alert.title"), message: Text(error.message), dismissButton: .cancel())
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            Button("activationScreen.activateButton", action: { viewModel.didTapActivateButton() })
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        case .loading:
            ProgressView()
        }
    }
}

#Preview {
    ActivationView(
        scratchCode: ScratchCode(value: UUID()),
        dependencyContainer: AppDependencyContainer().makeMainDependencyContainer().makeActivationDependencyContainer()
    )
}
