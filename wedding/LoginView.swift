import SwiftUI

func validEmail(input: String) -> Bool {
    let emailPattern = #"^\S+@\S+\.\S+$"#
    let result = input.range(
        of: emailPattern,
        options: .regularExpression
    )
    let validEmail = (result != nil)
    return validEmail
}

class UserAuth: ObservableObject {
    static let shared = UserAuth()
    @Published private(set) var isLoggedIn = false
    @Published private(set) var submitting = false
    @Published private(set) var submitted = false
    
    func logOff(){
        isLoggedIn = false
        submitting = false
        submitted = false
    }
    
    func logIn(passCode: String){
        
        let verification = verify(input: passCode)
        
        if verification == "hardcoded" {
            isLoggedIn = true
        }
        else if verification == "softcoded" {
            isLoggedIn = true
        }
        else if verification == "pending"{
            submitting = true
        }
    }
    
    func submitted(input: String = ""){
        submitted = true
    }
    
    
    
    func verify(input: String) -> String{
        let validEmail = validEmail(input: input)
        if(validEmail){
            if(input.lowercased() == "nate@nate.nate" || input.lowercased() == "apple@apple.apple"){
                return "hardcoded"
            }else if(inOnlineList(input: input)){
                return "softcoded"
            }else{
                return "pending"
            }
        }else{
            return "non-email" //do nothing for invalid email
        }
        //return "unknown-error" //should never reach this
    }
    
    func inOnlineList(input: String) -> Bool{
        return false
    }
}

extension View {
    @ViewBuilder
    func requiresAuthentication() -> some View {
        if UserAuth.shared.isLoggedIn {
            self
        } else if UserAuth.shared.submitting && !UserAuth.shared.submitted {
            TabView{
                ShareYourInfoView()
                    .tabItem{
                        Image(systemName: "square.and.pencil")
                    }
                SettingsView()
                    .tabItem{
                        Image(systemName: "gear")
                    }
            }
            //show a view that allows logout to password and a message that theyre on the list
        } else if UserAuth.shared.submitted {
            TabView{
                Text("Thanks! We will email you when approved!")
                    .tabItem{
                        Image(systemName: "square.and.pencil")
                    }
                SettingsView()
                    .tabItem{
                        Image(systemName: "gear")
                    }
            }
        }
        else {
            PasswordPageView()
        }
    }
}
