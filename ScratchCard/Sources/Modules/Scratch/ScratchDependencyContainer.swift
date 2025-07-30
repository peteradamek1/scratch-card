final class ScratchDependencyContainer {
    
    // MARK: - Stored properties

    private let scratchCodeRepository: ScratchCodeRepositoryType
    
    // MARK: - Initialization
    
    init(scratchCodeRepository: ScratchCodeRepositoryType) {
        self.scratchCodeRepository = scratchCodeRepository
    }
    
    // MARK: - View model
    
    func makeViewModel() -> ScratchViewModel {
        return ScratchViewModel(revealScratchCodeUseCase: makeRevealScratchCodeUseCase())
    }
    
    // MARK: - Use cases
    
    private func makeRevealScratchCodeUseCase() -> RevealScratchCodeUseCaseType {
        return RevealScratchCodeUseCase(scratchCodeRepository: scratchCodeRepository)
    }
}
