import SwiftUI

extension View{
    // MARK: Safe Area Value
    func safeArea()->UIEdgeInsets{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return .zero}
        guard let safeArea = window.windows.first?.safeAreaInsets else{return .zero}
        
        return safeArea
    }
}

struct PasswordPageView: View {
    var body: some View {
        AnimatedSplashScreen(color: "Yellow", logo: "SwiftLogo",animationTiming: 0.65) {
            // MARK: Your Home View
        } onAnimationEnd: {
            print("Animation Ended")
        }
    }
}

// MARK: Custom View Builder
struct AnimatedSplashScreen<Content: View>: View {
    var content: Content
    // MARK: Properties
    var color: String
    var logo: String
    var barHeight: CGFloat = 60
    var animationTiming: Double = 0.65
    var onAnimationEnd: ()->()
    init(color: String,logo: String,barHeight: CGFloat = 60,animationTiming: Double = 0.65,@ViewBuilder content: @escaping ()->Content,onAnimationEnd: @escaping ()->()){
        self.content = content()
        self.onAnimationEnd = onAnimationEnd
        self.color = color
        self.logo = logo
        self.barHeight = barHeight
        self.animationTiming = animationTiming
    }
    // MARK: Animation Properties
    @State var startAnimation: Bool = false
    @State var animateContent: Bool = false
    @Namespace var animation
    
    // MARK: Controls and Callbacks
    @State var disableControls: Bool = true
    @State var password: String = ""
    var body: some View {
        VStack(spacing: 0){
            if startAnimation{
                GeometryReader{ proxy in
                    VStack(spacing: 0){
                        Image("SplashImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: "SPLASHICON", in: animation)
                        Text("Use your Email Address to continue").padding()
                        TextField("nate@thx1766.dev", text: $password)
                        Button(action: {
                            print("Button action")
                            UserAuth.shared.logIn(passCode: password)
                        }) {
                            Text("Click to Verify")
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .transition(.identity)
                .onAppear {
                    if !animateContent{
                        withAnimation(.easeInOut(duration: animationTiming)){
                            animateContent = true
                        }
                    }
                }
            }else{
                  Image("SplashImage")
                    .matchedGeometryEffect(id: "SPLASHICON", in: animation)
            }
        }
        .onAppear {
            if !startAnimation{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                    withAnimation(.easeInOut(duration: animationTiming)){
                        startAnimation = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + (animationTiming - 0.05)){
                    disableControls = false
                    onAnimationEnd()
                }
            }
        }
    }
}

