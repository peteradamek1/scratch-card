import Combine
import SwiftUICore

final class MainViewModel: ObservableObject {
    
    // MARK: - Publishers
    
    @Published var error: CommonError?
    @Published private(set) var isActivateButtonDisabled = true
    @Published private(set) var isLoading = false
    @Published private(set) var isScratchButtonDisabled = false
    @Published var shouldNavigateToScratchScreen = false
    @Published var shouldNavigateToActivationScreen = false
    @Published private(set) var subtitle: LocalizedStringKey?
    
    private let scratchCardVersionPublisher: CurrentValueSubject<ScratchCardVersion, Never>

    // MARK: - Stored properties
    
    private var cancellables = Set<AnyCancellable>()
    private let checkScratchCardValidityUseCase: CheckScratchCardValidityUseCaseType
    private var scratchCardState: ScratchCardState {
        didSet {
            resolveViewState(for: scratchCardState)
        }
    }
    private(set) var scratchCode: ScratchCode?

    // MARK: - Initialization
    
    init(
        checkScratchCardValidityUseCase: CheckScratchCardValidityUseCaseType,
        getScratchCardVersionPublisherUseCase: GetScratchCardVersionPublisherUseCaseType
    ) {
        self.checkScratchCardValidityUseCase = checkScratchCardValidityUseCase
        scratchCardVersionPublisher = getScratchCardVersionPublisherUseCase.execute()
        scratchCardState = .unscratched

        subscribeToScratchCardVersionPublisher()
    }
    
    // MARK: - User actions
    
    func didTapScratchButton() {
        shouldNavigateToScratchScreen = true
    }
    
    func didTapActivateButton() {
        shouldNavigateToActivationScreen = true
    }
    
    // MARK: - Public methods
    
    func didRevealScratchCode(_ scratchCode: ScratchCode) {
        self.scratchCode = scratchCode
        scratchCardState = .scratched
        shouldNavigateToScratchScreen = false
    }

    // MARK: - Private methods
    
    private func resolveViewState(for scratchCardState: ScratchCardState) {
        let isScratchButtonDisabled: Bool
        let isActivateButtonDisabled: Bool
        let subtitle: LocalizedStringKey

        switch scratchCardState {
        case .unscratched:
            isScratchButtonDisabled = false
            isActivateButtonDisabled = true
            subtitle = "mainScreen.subtitle.unscratched"
        case .scratched:
            isScratchButtonDisabled = true
            isActivateButtonDisabled = false
            subtitle = "mainScreen.subtitle.scratched"
        case .activated:
            isScratchButtonDisabled = true
            isActivateButtonDisabled = true
            subtitle = "mainScreen.subtitle.activated"
        }
        
        self.isScratchButtonDisabled = isScratchButtonDisabled
        self.isActivateButtonDisabled = isActivateButtonDisabled
        self.subtitle = subtitle
    }
    
    private func subscribeToScratchCardVersionPublisher() {
        scratchCardVersionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.handleScratchCardVersion($0)
            }
            .store(in: &cancellables)
    }
    
    private func handleScratchCardVersion(_ scratchCardVersion: ScratchCardVersion) {
        let isLoading: Bool
        
        switch scratchCardVersion {
        case .loaded(let version):
            let isScratchCardValid = checkScratchCardValidityUseCase.execute(cardVersion: version)

            if  isScratchCardValid {
                scratchCardState = .activated
                shouldNavigateToActivationScreen = false
            } else {
                error = CommonError(message: "mainScreen.cardUnsupportedError")
            }
            
            isLoading = false
        case .loading:
            isLoading = true
        case .unknown:
            isLoading = false
        }
        
        self.isLoading = isLoading
    }
}
