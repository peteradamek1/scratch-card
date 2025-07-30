final class ActivationDependencyContainer {
    
    // MARK: - Stored properties

    private let scratchCodeRepository: ScratchCodeRepositoryType
    
    // MARK: - Initialization
    
    init(scratchCodeRepository: ScratchCodeRepositoryType) {
        self.scratchCodeRepository = scratchCodeRepository
    }

    // MARK: - View model
    
    func makeViewModel(scratchCode: ScratchCode) -> ActivationViewModel {
        return ActivationViewModel(
            activateScratchCardUseCase: makeActivateScratchCardUseCase(),
            scratchCode: scratchCode
        )
    }
    
    // MARK: - Use cases
    
    private func makeActivateScratchCardUseCase() -> ActivateScratchCardUseCaseType {
        return ActivateScratchCardUseCase(scratchCodeRepository: scratchCodeRepository)
    }

}
