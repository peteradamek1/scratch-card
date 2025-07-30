protocol ActivateScratchCardUseCaseType {

    func execute(_ scratchCode: ScratchCode) async throws -> ScratchCardVersion
}

final class ActivateScratchCardUseCase: ActivateScratchCardUseCaseType {
    
    // MARK: - Stored properties
    
    private let scratchCodeRepository: ScratchCodeRepositoryType
    
    // MARK: - Initialization
    
    init(scratchCodeRepository: ScratchCodeRepositoryType) {
        self.scratchCodeRepository = scratchCodeRepository
    }

    // MARK: - ActivateScratchCardUseCaseType

    func execute(_ scratchCode: ScratchCode) async throws -> ScratchCardVersion {
        return try await scratchCodeRepository.sendScratchCode(scratchCode)
    }
}
