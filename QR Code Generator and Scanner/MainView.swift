//
//  MainView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
      TabView{
        QRGenerateView()
          .tabItem {
            Image(systemName: "qrcode")
            Text("Generator")
          }
        ScannerView()
          .tabItem {
            Image(systemName: "qrcode.viewfinder")
            Text("Scanner")
          }
      }
    }
}

#Preview {
    MainView()
}
