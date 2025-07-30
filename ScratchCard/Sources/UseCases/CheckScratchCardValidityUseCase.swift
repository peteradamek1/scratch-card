protocol CheckScratchCardValidityUseCaseType {
    
    /// - Returns: `true` if the card is valid; otherwise `false`.
    func execute(cardVersion: String) -> Bool
}

final class CheckScratchCardValidityUseCase: CheckScratchCardValidityUseCaseType {
    
    private enum Constants {
        static let maxUnsupportedScratchCardVersion = 6.1
    }

    func execute(cardVersion: String) -> Bool {
        guard let versionNumber = Double(cardVersion) else { return false }
        return versionNumber > Constants.maxUnsupportedScratchCardVersion
    }
}
