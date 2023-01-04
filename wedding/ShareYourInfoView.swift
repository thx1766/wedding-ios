import SwiftUI

struct ShareYourInfoView: View {
    @State var fname: String = ""
    @State var lname: String = ""
    @State var emailAddress: String = UserAuth.shared.submitting_email
    @State var notes: String = ""
    
    var body: some View {
        VStack{
            VStack{
                Text("We didn't recognize that email!\n\n")
                Text("Please share the following:\n\n")
            }
            VStack(alignment: .leading){
                Text("First Name")
                TextField("Nathanial", text: $fname)
                Text("Last Name")
                TextField("Schaffner", text: $lname)
                Text("Email Address")
                TextField("nate@thx1766.dev", text: $emailAddress)
            }
            VStack{
                Text("Notes")
                TextField("Not required - share anything helpful!", text: $notes).lineLimit(3)
                Button(action: {
                    if(fname != "" && lname != "" && emailAddress != ""){
                        if(validEmail(input: emailAddress)){
                            print("Submit email action")
                            UserAuth.shared.addEmailToServer(f: fname, l: lname, e: emailAddress, n: notes)
                        }
                        else{
                            print("bad email address")
                        }
                    }else{
                        print("missing form data")
                    }
                }) {
                    Text("Click to Submit")
                }
            }
        }
    }
}

struct ShareYourInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ShareYourInfoView()
    }
}
