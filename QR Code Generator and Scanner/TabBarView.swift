
import SwiftUI

struct TabBar : Identifiable {
  var id = UUID()
  var icon : String
  var tabIcon : TabIcon
  var index : Int
}



let tabItems = [TabBar(icon: "qrcode", tabIcon: .Qrcode, index: 0),
                TabBar(icon: "qrcode.viewfinder", tabIcon: .Scanner, index: 1)]


enum TabIcon : String {
  case Qrcode
  case Scanner
}
struct TabBarView: View {
  @Binding var selectedTabItem: TabIcon
  @State var Xoffset = 0.0
  var body: some View {
      HStack{
        ForEach(tabItems){ item  in
          Spacer()
          Image(systemName: item.icon)
            .foregroundColor(.black)
            .onTapGesture {
              selectedTabItem = item .tabIcon
              Xoffset =  CGFloat(item.index) * 70
            }
          Spacer()
        }
        .frame(width: 23.3)
      }
      .frame(height: 70)
      .background(.white,in: RoundedRectangle(cornerRadius: 10))
      .overlay(alignment: .bottomLeading){
        Circle().frame(width: 10,height: 10).foregroundColor(.black)
          .offset(x: 30, y: -5)
          .offset(x: Xoffset)
      }
  }
}
#Preview {
  TabBarView(selectedTabItem: .constant(.Qrcode))
}
