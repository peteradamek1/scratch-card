import Foundation

protocol ScratchCodeGeneratorServiceType {
    
    func generateScratchCode() async throws -> UUID
}

final class ScratchCodeGeneratorService: ScratchCodeGeneratorServiceType {
    
    func generateScratchCode() async throws -> UUID {
        return try await withTaskCancellationHandler(
            operation: {
                try await Task.sleep(for: .seconds(2))
                try Task.checkCancellation()
                return UUID()
            },
            onCancel: {}
        )
    }
}
