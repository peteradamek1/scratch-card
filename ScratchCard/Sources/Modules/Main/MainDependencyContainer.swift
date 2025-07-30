final class MainDependencyContainer {
    
    // MARK: - Stored properties
    
    private lazy var scratchCardVersionService = makeScratchCardVersionService()
    
    // MARK: - View model
    
    func makeViewModel() -> MainViewModel {
        return MainViewModel(
            checkScratchCardValidityUseCase: makeCheckScratchCardValidityUseCaseType(),
            getScratchCardVersionPublisherUseCase: makeGetScratchCardVersionPublisherUseCase()
        )
    }
    
    // MARK: - Dependency containers

    func makeScratchDependencyContainer() -> ScratchDependencyContainer {
        return ScratchDependencyContainer(scratchCodeRepository: makeScratchCodeRepository())
    }
    
    func makeActivationDependencyContainer() -> ActivationDependencyContainer {
        return ActivationDependencyContainer(scratchCodeRepository: makeScratchCodeRepository())
    }
    
    // MARK: - Use cases
    
    private func makeCheckScratchCardValidityUseCaseType() -> CheckScratchCardValidityUseCaseType {
        return CheckScratchCardValidityUseCase()
    }
    
    private func makeGetScratchCardVersionPublisherUseCase() -> GetScratchCardVersionPublisherUseCaseType {
        return GetScratchCardVersionPublisherUseCase(scratchCardVersionService: scratchCardVersionService)
    }

    // MARK: - Repositories
    
    func makeScratchCodeRepository() -> ScratchCodeRepositoryType {
        return ScratchCodeRepository(
            apiService: makeAPIService(),
            scratchCardVersionService: scratchCardVersionService,
            scratchCodeGeneratorService: makeScratchCodeGeneratorService()
        )
    }
    
    // MARK: - Services
    
    private func makeAPIService() -> APIServiceType {
        return APIService()
    }
    
    private func makeScratchCardVersionService() -> ScratchCardVersionServiceType {
        return ScratchCardVersionService()
    }
    
    private func makeScratchCodeGeneratorService() -> ScratchCodeGeneratorServiceType {
        return ScratchCodeGeneratorService()
    }
}
