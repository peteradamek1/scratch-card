import XCTest
@testable import ScratchCard

final class CheckScratchCardValidityUseCaseTests: XCTestCase {
    
    private var useCase: CheckScratchCardValidityUseCase!

    override func setUp() {
        super.setUp()
        useCase = CheckScratchCardValidityUseCase()
    }

    func test_execute_withCardVersionGreaterThanMaxUnsupported() {
        let result = useCase.execute(cardVersion: "6.2")
        XCTAssertTrue(result)
    }

    func test_execute_withCardVersionEqualToMaxUnsupported() {
        let result = useCase.execute(cardVersion: "6.1")
        XCTAssertFalse(result)
    }

    func test_execute_withCardVersionLessThanMaxUnsupported() {
        let result = useCase.execute(cardVersion: "5.9")
        XCTAssertFalse(result)
    }

    func test_execute_withNonNumericCardVersion() {
        let result = useCase.execute(cardVersion: "invalid")
        XCTAssertFalse(result)
    }

    func test_execute_withEmptyCardVersion() {
        let result = useCase.execute(cardVersion: "")
        XCTAssertFalse(result)
    }

    func test_execute_withCardVersionSlightlyAboveMaxUnsupported() {
        let result = useCase.execute(cardVersion: "6.1001")
        XCTAssertTrue(result)
    }
}
