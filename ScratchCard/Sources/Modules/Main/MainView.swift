import SwiftUI

struct MainView: View {
    
    private enum Layout {
        static let subtitlePaddingTop: CGFloat = 16
        static let bottomButtonsSpacing: CGFloat = 16
    }
    
    // MARK: - State
    
    @StateObject private var viewModel: MainViewModel
    
    @State private var isLoading = false
    
    // MARK: - Stored properties
    
    private let mainDependencyContainer: MainDependencyContainer
    
    // MARK: - Initialization
    
    init(mainDependencyContainer: MainDependencyContainer) {
        _viewModel = StateObject(wrappedValue: mainDependencyContainer.makeViewModel())
        self.mainDependencyContainer = mainDependencyContainer
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("mainScreen.navigationTitle")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $viewModel.shouldNavigateToScratchScreen) {
                    ScratchView(
                        onScratchCodeRevealed: { viewModel.didRevealScratchCode($0) },
                        dependencyContainer: mainDependencyContainer.makeScratchDependencyContainer()
                    )
                }
                .navigationDestination(isPresented: $viewModel.shouldNavigateToActivationScreen) {
                    if let scratchCode = viewModel.scratchCode {
                        ActivationView(
                            scratchCode: scratchCode,
                            dependencyContainer: mainDependencyContainer.makeActivationDependencyContainer()
                        )
                    }
                }
                .onChange(of: viewModel.isLoading) { _, newValue in
                    withAnimation {
                        isLoading = newValue
                    }
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("common.alert.title"), message: Text(error.message), dismissButton: .cancel())
                }
        }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            
            Text("mainScreen.title")
                .font(.headline)
            
            if let subtitle = viewModel.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .padding(.top, Layout.subtitlePaddingTop)
            }
            
            Spacer()

            if isLoading {
                ProgressView()
            } else {
                HStack(spacing: Layout.bottomButtonsSpacing) {
                    Group {
                        Button("mainScreen.scratchButton", action: { viewModel.didTapScratchButton() })
                            .disabled(viewModel.isScratchButtonDisabled)
                        
                        Button("mainScreen.activateButton", action: { viewModel.didTapActivateButton() })
                            .disabled(viewModel.isActivateButtonDisabled)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
        }
        .padding()
    }
}

#Preview {
    MainView(mainDependencyContainer: MainDependencyContainer())
}
