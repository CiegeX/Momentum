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
                Section(header: Text("Momentum").font(.headline)) {
                    NavigationLink(destination: AboutUs()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("About us")
                        }
                    }
                    
                    NavigationLink(destination: PrivacyPolicy()) {
                        HStack {
                            Image(systemName: "key")
                            Text("Privacy Policy ")
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

struct AboutUs: View {
    var body: some View {
        Text("About Us Page")
            .navigationTitle("About Us")
    }
}
struct PrivacyPolicy: View {
    var body: some View {
        Text("Privacy Policy Page")
            .navigationTitle("Privacy Policy")
    }
}

#Preview {
    Settings()
}

