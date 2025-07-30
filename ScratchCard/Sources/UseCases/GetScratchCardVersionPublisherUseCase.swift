import Combine

protocol GetScratchCardVersionPublisherUseCaseType {
    func execute() -> CurrentValueSubject<ScratchCardVersion, Never>
}

final class GetScratchCardVersionPublisherUseCase: GetScratchCardVersionPublisherUseCaseType {
    
    // MARK: - Stored properties
    
    private let scratchCardVersionService: ScratchCardVersionServiceType
    
    // MARK: - Initialization
    
    init(scratchCardVersionService: ScratchCardVersionServiceType) {
        self.scratchCardVersionService = scratchCardVersionService
    }
    
    // MARK: - GetScratchCardVersionPublisherUseCaseType
    
    func execute() -> CurrentValueSubject<ScratchCardVersion, Never> {
        return scratchCardVersionService.scratchCardVersionPublisher
    }
}
