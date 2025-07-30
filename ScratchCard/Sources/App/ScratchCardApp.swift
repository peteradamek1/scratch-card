import SwiftUI

@main
struct ScratchCardApp: App {
    
    private let appDependencyContainer = AppDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            MainView(mainDependencyContainer: appDependencyContainer.makeMainDependencyContainer())
        }
    }
}
