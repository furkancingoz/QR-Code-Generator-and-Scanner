//
//  MainView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct MainView: View {
//  @State var selectedTabItem: TabIcon = .Qrcode
  var body: some View {
    TabView{
    QRGenerateView()
    .tabItem {
    Image(systemName: "qrcode")
    Text("QR Code Generator")
    }

    ScannerView()
    .tabItem {
    Image(systemName: "qrcode.viewfinder")
    Text("Scanner")
    }
    }
    .tabViewStyle(.page)
//    VStack{
//      ZStack(alignment: .bottom) {
//        // View'ları seçili tab'a göre göster
//        switch selectedTabItem {
//        case .Qrcode:
//          QRGenerateView()
//        case .Scanner:
//          ScannerView()
//        }
//
//        // TabBarView'de seçili tab'ı güncelle
//Spacer()
//        TabBarView(selectedTabItem: $selectedTabItem)
//          .padding(.bottom,25)
//      }
//      .edgesIgnoringSafeArea(.all)
//    }
  }
}
#Preview {
  MainView()
}
