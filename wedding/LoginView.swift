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
    @Published private(set) var submitting_email = ""
    @Published private(set) var submitted = false
    @Published private(set) var submitted_email = ""
    @Published private(set) var showNetworkError = false
    
    func addEmailToServer(f: String, l: String, e: String, n: String){
        // Prepare URL
//POST URL HERE
//POST URL HERE
//POST URL HERE
        let url = URL(string: "https://schdom.com/weddingusers/")
//POST URL HERE
//POST URL HERE
//POST URL HERE
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body

        let postString = "firstname=\(f)&lastname=\(l)&emailaddress=\(e)&note=\(n)"
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
        submitted(input: e)
    }
    
    func logOff(){
        isLoggedIn = false
        submitting = false
        submitted = false
        showNetworkError = false
        submitting_email = ""
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
            submitting_email = passCode
        }
        else if verification == "networkingError"{
            showNetworkError = true
        }
    }
    
    func submitted(input: String){
        submitted = true
        submitted_email = input
    }
    
    func verify(input: String) -> String{
        let validEmail = validEmail(input: input)
        if(validEmail){
            if(input.lowercased() == "nate@nate.nate" || input.lowercased() == "apple@apple.apple"){
                return "hardcoded"
            }else if(inOnlineList(input: input) == "networkingError"){
                return "networkingError"
            }else if(inOnlineList(input: input) == "true"){
                return "softcoded"
            }else{
                return "pending"
            }
        }else{
            return "non-email" //do nothing for invalid email
        }
        //return "unknown-error" //should never reach this
    }
    
    func getUserEmailsFromServer() -> [String] {
        print("in function retrieving data from server")
        let session = URLSession.shared
        var results: [String] = []
//GET URL HERE
//GET URL HERE
//GET URL HERE
        guard let url = URL(string: "https://schdom.com/weddingusers/") else {
//GET URL HERE
//GET URL HERE
//GET URL HERE
            print("fatal error with url")
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let sem = DispatchSemaphore.init(value: 0)
        
        var connectionError: Bool = false
        
        session.dataTask(with: urlRequest){
            (data, response, error) in
            sem.signal()
            if error != nil{
                connectionError = true
                print("connection error detected")
                return
            }
        }.resume()
        sem.wait()
        
        if(connectionError){
            print("connectivity error")
            return ["networkingError"]
        }
        else{
            print("no connection error")
        
        let dataTask = session.dataTask(with: urlRequest){
            (data, response, error) in

            if let error = error {
                print("Request error", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else {return}
                    defer {sem.signal()}
                    do{
                        let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                        for listeduser: User in decodedUsers {
                            results.append(listeduser.emailaddress)
                        }
                    }catch let error{
                        print("error decoding: \(error)")
                    }
            }
            else
            {
                return
            }
        }
        dataTask.resume()
        
        sem.wait()
        
        }
        return results
    }
    
    func inOnlineList(input: String)  -> String{
        let userEmailList: [String] =  getUserEmailsFromServer()
        print("user emails: \(userEmailList)")
        print("inside inOnlineList function")
        if(userEmailList.contains("networkingError")){
            return "networkingError"
        }
        if(userEmailList.contains(input)) {
            print("found email(\(input)) in list")
            return "true"
        }
        else{
            print("did not find email(\(input)) in list")
            return "false"
        }
    }
}

extension View {
    @ViewBuilder
    func requiresAuthentication() -> some View {
        if UserAuth.shared.isLoggedIn {
            self
        }else if UserAuth.shared.showNetworkError{
            TabView{
                Text("Network Error!\n\nWe were unable to verify your email address.\n\nThe server might be down.\n\nPlease log out via the settings menu and try again later.\n\nWhile you wait, check out our wedding website at https://schdom.com\n\nFeel free to let me know about the problem at nate@thx1766.dev 😎")
                    .tabItem{
                        Image(systemName: "wifi.exclamationmark")
                    }
                SettingsView()
                    .tabItem{
                        Image(systemName: "gear")
                    }
            }
        }
        else if UserAuth.shared.submitting && !UserAuth.shared.submitted {
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
                Text("Thanks! We will email \(UserAuth.shared.submitted_email) when approved!")
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

struct User: Decodable {
    var firstname: String
    var lastname: String
    var emailaddress: String
    var note: String?
}
