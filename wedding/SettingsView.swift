import SwiftUI

struct SettingsView: View {
    var body: some View {
        Button{
            UserAuth.shared.logOff()
        }label:{
            Text("< Logout")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
