import Foundation

final class ScratchViewModel: ObservableObject {
    
    enum ViewState: Equatable {
        case idle
        case loading
        case error(messageKey: String)
    }
    
    // MARK: - Publishers
    
    @Published private(set) var scratchCode: ScratchCode?
    @Published private(set) var viewState = ViewState.idle
    
    // MARK: - Stored properties
    
    private var revealScratchCodeTask: Task<Void, Never>?
    private let revealScratchCodeUseCase: RevealScratchCodeUseCaseType

    // MARK: - Initialization
    
    init(revealScratchCodeUseCase: RevealScratchCodeUseCaseType) {
        self.revealScratchCodeUseCase = revealScratchCodeUseCase
    }

    // MARK: - Lifecycle
    
    deinit {
        revealScratchCodeTask?.cancel()
    }

    // MARK: - User actions
    
    func didTapRevealCodeButton() {
        revealScratchCode()
    }
    
    // MARK: - Private methods
    
    private func revealScratchCode() {
        viewState = .loading
        
        revealScratchCodeTask = Task { [weak self] in
            do {
                let scratchCode = try await self?.revealScratchCodeUseCase.execute()

                guard let self else { return }
                await MainActor.run {
                    self.scratchCode = scratchCode
                }
            } catch is CancellationError {
                print("Revealing scratch code cancelled")
            } catch {
                guard let self else { return }
                await MainActor.run {
                    self.viewState = .error(messageKey: "scratch.revealingCodeFailed")
                }
            }
        }
    }
}
