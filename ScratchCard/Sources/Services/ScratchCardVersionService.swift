import Combine

protocol ScratchCardVersionServiceType {
    
    var scratchCardVersionPublisher: CurrentValueSubject<ScratchCardVersion, Never> { get }
    
    func setScratchCardVersion(_ scratchCardVersion: ScratchCardVersion)
}

final class ScratchCardVersionService: ScratchCardVersionServiceType {
    
    private(set) var scratchCardVersionPublisher = CurrentValueSubject<ScratchCardVersion, Never>(.unknown)
    
    func setScratchCardVersion(_ scratchCardVersion: ScratchCardVersion) {
        print("scratch card version: \(scratchCardVersion.formatted)")
        scratchCardVersionPublisher.send(scratchCardVersion)
    }
}
