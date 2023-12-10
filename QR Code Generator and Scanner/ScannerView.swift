//
//  ScannerView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct ScannerView: View {
  //qecode scanner properties

  @State private var isScanning : Bool = false

  var body: some View {
    VStack{
      Button{

      } label: {
        Image(systemName: "xmark")
          .font(.title3)
          .foregroundColor(.blue)
      }
      .frame(maxWidth: .infinity,alignment: .leading)

      Text("Place the QR Code inside the area")
        .font(.title3)
        .foregroundColor(.white.opacity(0.8))
        .padding(.top,20)

      Text("Scanning will start automatically")
        .font(.callout)
        .foregroundStyle(.gray)

      Spacer(minLength: 0)

      //MARK: - SCANNER
      GeometryReader {
        let size = $0.size

        ZStack{

          ForEach(0...4, id: \.self){ index in
            let rotation = Double(index) * 90
            RoundedRectangle(cornerRadius: 2, style: .circular)
            //trim edge
              .trim(from: 0.61,to: 0.64)
              .stroke(style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin:.round))
              .rotationEffect(.init(degrees: rotation))

          }

        }
        //square shape
        .frame(width: size.width, height: size.width)
        .overlay(alignment: .top, content: {
          Rectangle()
            .fill(Color.red)
            .frame(height: 2.5)
            .shadow(color:.white.opacity(0.8),radius: 8, x:0,y:isScanning ? 15 : -15)
            .offset(y: isScanning ?  size.width : 0)
        })
        //center
        .frame(maxWidth: .infinity,maxHeight: .infinity)

      }


      Spacer(minLength: 0)

      Button{
        //action
      } label: {
        Image(systemName: "qrcode.viewfinder")
          .font(.largeTitle)
          .foregroundColor(.gray)
      }

      Spacer(minLength: 45)
    }
    .padding(15)
    
  }
  //activation scanner animation method
  func activateScannerAnimation(){
    withAnimation(.easeOut(duration: 0.80).delay(0.1).repeatForever(autoreverses: true)) {
      isScanning = true
    }
  }
}
#Preview {
  ScannerView()
}
