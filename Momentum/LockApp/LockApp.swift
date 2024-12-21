import SwiftUI
import FamilyControls
import ManagedSettings

struct LockApp: View {
    @State private var selectedApps = FamilyActivitySelection()
    @State private var blockDuration = 1.0 // Default to 1 hour
    @State private var isBlocking = false
    @EnvironmentObject private var model: AppBlockingModel
    
    var body: some View {
        VStack {
            Text("Select Apps to Block")
                .font(.headline)
            
            FamilyActivityPicker(selection: $selectedApps)
                .frame(height: 300) // Adjust the height as needed
            
            HStack {
                Text("Block Duration:")
                Slider(value: $blockDuration, in: 0.5...8, step: 0.5)
                Text("\(Int(blockDuration)) hrs")
            }
            .padding()
            
            Button(action: {
                startBlocking()
            }) {
                Text("Block Selected Apps")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedApps.applications.isEmpty || isBlocking)
            
            if isBlocking {
                Text("Apps are currently blocked!")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    private func startBlocking() {
        guard !selectedApps.applications.isEmpty else { return }
        
        // Correctly create ApplicationToken for each app
        let applicationTokens = Set(selectedApps.applications.compactMap { app in
            try? ApplicationToken(from: app as! Decoder)
        })
        
        // Create restrictions
        model.store.shield.applications = .some(applicationTokens)
        
        // Apply the restrictions
        let blockEndTime = Date().addingTimeInterval(blockDuration * 3600)
        model.startBlocking(until: blockEndTime)
        
        isBlocking = true
        
        // Schedule unblocking after the duration
        DispatchQueue.main.asyncAfter(deadline: .now() + blockDuration * 3600) {
            stopBlocking()
        }
    }

    
    private func stopBlocking() {
        model.store.shield.applications = nil
        isBlocking = false
    }
}

#Preview {
    LockApp()
}
