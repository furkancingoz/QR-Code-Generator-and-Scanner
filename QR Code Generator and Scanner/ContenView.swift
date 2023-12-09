//
//  ContenView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct ContenView: View {
    var body: some View {
      VStack{
Image(systemName: "qr")
          .resizable()
          .frame(width: 250,height: 250)

      }
    }
}

#Preview {
    ContenView()
}
