import SwiftUI

@main
struct IRDApp: App {
    @StateObject var sceneFlowState = SceneFlowState()
    
    var body: some Scene {
        WindowGroup {
            switch sceneFlowState.sceneFlow {
            case .signin:
                SigninView()
                    .environmentObject(sceneFlowState)
                
            case .home:
                HomeView()
                    .environmentObject(sceneFlowState)
            }
        }
    }
}
