import SwiftUI

struct Settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = false // State for the toggle
    
    var body: some View {
        NavigationView {
            List {
                // Section for Account Settings
                Section(header: Text("Account Settings").font(.headline)) {
                    NavigationLink(destination: Profile()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Edit Profile")
                        }
                    }
                    
                    NavigationLink(destination: ChangePasswordView()) {
                        HStack {
                            Image(systemName: "key")
                            Text("Change Password")
                        }
                    }
                }
                
                // Section for Preferences
                Section(header: Text("Preferences").font(.headline)) {
                    NavigationLink(destination: PushNotificationsView()) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Push Notifications")
                        }
                    }
                    
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .foregroundColor(isDarkMode ? .yellow : .gray)
                            Text("Dark Mode")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}


struct ChangePasswordView: View {
    var body: some View {
        Text("Change Password Page")
            .navigationTitle("Change Password")
    }
}

struct PushNotificationsView: View {
    var body: some View {
        Text("Push Notifications Page")
            .navigationTitle("Push Notifications")
    }
}

#Preview {
    Settings()
}

