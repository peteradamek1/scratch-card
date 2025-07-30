import SwiftUICore

struct CommonError: Identifiable {
    
    let message: LocalizedStringKey
    
    // MARK: - Identifiable
    
    var id: String {
        "\(message)"
    }
}
