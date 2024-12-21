
import SwiftUI

struct Navbar: View {
    @StateObject private var model = AppBlockingModel.shared
    
    var body: some View {
        TabView {
            Timer()
                .tabItem {
                    Label("Timer", systemImage: "clock")
                }
            LockApp()
                .environmentObject(model)
                .tabItem {
                    Label("LockApp", systemImage: "lock")
                }
            AI()
                .tabItem {
                    Label("AI", systemImage: "plus")
                }
            Social()
                .tabItem {
                    Label("Social", systemImage: "person")
                }
            Account()
                .tabItem {
                    Label("Account", systemImage: "gear")
                }
        }
    }
}
