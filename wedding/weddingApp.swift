import SwiftUI

@main
struct weddingApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}

// it's working it looks like

struct AuthView: View {
    
    @StateObject private var userAuth = UserAuth.shared

    var body: some View {
        TabView{
            DetailsView()
                .tabItem{
                    Image(systemName: "party.popper" )
                }
            PhotoView()
                .tabItem{
                    Image(systemName: "photo")
                }
            Engagement_Ring_View()
                .tabItem{
                    Image(systemName: "sparkle")
                }
            Wedding_Ring_View()
                .tabItem{
                    Image(systemName: "sparkles")
                }
            SettingsView()
                .tabItem{
                    Image(systemName: "gear")
                }
        }
        .requiresAuthentication()
    }
}
