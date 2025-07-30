import Foundation

final class ActivationViewModel: ObservableObject {
    
    enum ViewState {
        case idle
        case loading
    }

    // MARK: - Publishers
    
    @Published var error: CommonError?
    @Published private(set) var viewState: ViewState = .idle

    // MARK: - Stored properties
    
    private let activateScratchCardUseCase: ActivateScratchCardUseCaseType
    private let scratchCode: ScratchCode
    
    // MARK: - Initialization
    
    init(activateScratchCardUseCase: ActivateScratchCardUseCaseType, scratchCode: ScratchCode) {
        self.activateScratchCardUseCase = activateScratchCardUseCase
        self.scratchCode = scratchCode
    }

    // MARK: - User actions
    
    func didTapActivateButton() {
        activateScratchCard()
    }
    
    // MARK: - Private methods
    
    private func activateScratchCard() {
        viewState = .loading
        
        Task { [weak self] in
            do {
                guard let activateScratchCardUseCase = self?.activateScratchCardUseCase,
                      let scratchCode = self?.scratchCode
                else { return }

                let scratchCardVersion = try await activateScratchCardUseCase.execute(scratchCode)

                if let self {
                    await MainActor.run {
                        self.handleScratchCardVersion(scratchCardVersion)
                    }
                }
            } catch {
                guard let self else { return }
                await MainActor.run {
                    self.viewState = .idle
                    self.error = CommonError(message: "common.genericError")
                }
            }
        }
    }
    
    private func handleScratchCardVersion(_ scratchCardVersion: ScratchCardVersion) {
        viewState = switch scratchCardVersion {
        case .loaded: .idle
        case .loading: .loading
        case .unknown: .idle
        }
    }
}
