import SwiftUI

enum ringTypeEnum {
    case engagement, wedding, alternateWedding
}

struct DetailsView: View{
    var body: some View{
        
        VStack{
            Text("Nathanial Schaffner")
                .foregroundColor(Color.orange)
                .font(.system(size: 30))
            Text("&")
                .font(.system(size: 36))
            Text("Danielle Dombro")
                .foregroundColor(Color.orange)
                .font(.system(size: 30))
            Text("are getting married")
                .font(.system(size: 20))
            Text ("October 7th, 2023")
                .foregroundColor(Color.orange)
                .font(.system(size: 20.0, weight: .bold))
                .foregroundStyle(.primary)
            Text("at the Windsor Ballroom in")
            Text("East Windsor, New Jersey")
                .foregroundColor(Color.orange)
                .font(.system(size: 20.0))
            }
            .padding(.all, 20.0)
            .padding(.vertical, 10)
            .frame(height: 280.0)
            .background(.ultraThinMaterial, in:
                            RoundedRectangle(cornerRadius: 30, style: .continuous))
            .cornerRadius(30.0)
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 20)
            .overlay(
                Image ("ring")
                    .resizable()
                    .aspectRatio (contentMode: .fit)
                    .frame(height: 190)
                    .offset (x: 100, y: -175)
            )
        }}
