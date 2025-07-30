enum ScratchCardVersion {
    
    case loaded(version: String)
    case loading
    case unknown
    
    var formatted: String {
        switch self {
        case .loaded(let version):
            "loaded: \(version)"
        case .loading:
            "loading"
        case .unknown:
            "unknown"
        }
    }
}
