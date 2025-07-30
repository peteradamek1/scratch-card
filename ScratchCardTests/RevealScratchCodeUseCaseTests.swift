import Combine
import XCTest
@testable import ScratchCard

final class RevealScratchCodeUseCaseTests: XCTestCase {
    
    func test_execute_isCancellable() async {
        
        let scratchCodeRepository = ScratchCodeRepository(
            apiService: MockApiService(),
            scratchCardVersionService: MockScratchCardVersionService(),
            scratchCodeGeneratorService: ScratchCodeGeneratorService()
        )
        
        let useCase = RevealScratchCodeUseCase(scratchCodeRepository: scratchCodeRepository)
        
        let task = Task {
            try await useCase.execute()
        }
        
        try? await Task.sleep(for: .seconds(1))
        task.cancel()
        
        do {
            _ = try await task.value
            XCTFail("Expected CancellationError but got success")
        } catch is CancellationError {
            // Cancellation propagated successfully
            XCTAssert(true)
        } catch {
            XCTFail("Expected CancellationError but got \(error)")
        }
    }
    
    private final class MockApiService: APIServiceType {

        func getScratchCardVersion(code: String) async throws -> ScratchCard.GetScratchCardVersionResponse {
            fatalError("Not needed for these tests")
        }
    }
    
    private final class MockScratchCardVersionService: ScratchCardVersionServiceType {

        let scratchCardVersionPublisher = CurrentValueSubject<ScratchCard.ScratchCardVersion, Never>(.unknown)
        
        func setScratchCardVersion(_ scratchCardVersion: ScratchCard.ScratchCardVersion) {
            fatalError("Not needed for these tests")
        }
    }
}
