protocol RevealScratchCodeUseCaseType: AnyObject {
    
    func execute() async throws -> ScratchCode
}


final class RevealScratchCodeUseCase: RevealScratchCodeUseCaseType {
    
    // MARK: - Stored properties
    
    private let scratchCodeRepository: ScratchCodeRepositoryType
    
    // MARK: - Initialization
    
    init(scratchCodeRepository: ScratchCodeRepositoryType) {
        self.scratchCodeRepository = scratchCodeRepository
    }
    
    // MARK: - RevealScratchCodeUseCaseType

    func execute() async throws -> ScratchCode {
        return try await scratchCodeRepository.getScratchCode()
    }
}
