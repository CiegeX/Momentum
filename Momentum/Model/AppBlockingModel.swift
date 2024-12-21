import SwiftUI
import FamilyControls
import ManagedSettings

class AppBlockingModel: ObservableObject {
    static let shared = AppBlockingModel()
    let store = ManagedSettingsStore()
    
    func startBlocking(until date: Date) {
        // The actual unblocking logic is handled in LockApp
    }
    
    func stopBlocking() {
        store.shield.applications = nil
    }
}
