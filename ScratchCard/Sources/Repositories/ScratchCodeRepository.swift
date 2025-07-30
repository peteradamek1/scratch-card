import Foundation

protocol ScratchCodeRepositoryType {
    
    func getScratchCode() async throws -> ScratchCode
    func sendScratchCode(_ code: ScratchCode) async throws -> ScratchCardVersion
}

final class ScratchCodeRepository: ScratchCodeRepositoryType {
    
    // MARK: - Stored properties
    
    private let apiService: APIServiceType
    private let scratchCardVersionService: ScratchCardVersionServiceType
    private let scratchCodeGeneratorService: ScratchCodeGeneratorServiceType
    
    // MARK: - Initialization
    
    init(
        apiService: APIServiceType,
        scratchCardVersionService: ScratchCardVersionServiceType,
        scratchCodeGeneratorService: ScratchCodeGeneratorServiceType
    ) {
        self.apiService = apiService
        self.scratchCardVersionService = scratchCardVersionService
        self.scratchCodeGeneratorService = scratchCodeGeneratorService
    }
    
    // MARK: - ScratchCodeRepositoryType

    func getScratchCode() async throws -> ScratchCode {
        return try await ScratchCode(value: scratchCodeGeneratorService.generateScratchCode())
    }
    
    func sendScratchCode(_ code: ScratchCode) async throws -> ScratchCardVersion {
        scratchCardVersionService.setScratchCardVersion(.loading)

        let scratchCardVersion: ScratchCardVersion
        do {
            let response = try await apiService.getScratchCardVersion(code: code.value.uuidString)
            scratchCardVersion = .loaded(version: response.ios)
            scratchCardVersionService.setScratchCardVersion(scratchCardVersion)
        } catch {
            scratchCardVersionService.setScratchCardVersion(.unknown)
            throw error
        }

        return scratchCardVersion
    }
}
