//
//  ContentView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 8.12.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
  @Binding var QRCodeImage : UIImage?
  @Binding var text : String
    var body: some View {
        VStack {
            Image(uiImage: QRCodeImage!)
            .resizable()
                .frame(width: 200,height: 200)
                .cornerRadius(5)
                .padding()
          Text("\(text) QR Code")
            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)

        }
    }
}
struct ContentView: View {
  @State private var text  = ""
  @State private var QRCodeImage : UIImage?
    var body: some View {
        ZStack {
LinearGradient
        }
    }
}

#Preview {
    ContentView()
}
