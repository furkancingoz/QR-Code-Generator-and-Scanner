//
//  ScannerView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct ScannerView: View {
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

          RoundedRectangle(cornerRadius: 2, style: .circular)
          //trim edge
            .trim(from: 0.61,to: 0.64)
            .stroke(style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin:.round))

          RoundedRectangle(cornerRadius: 2, style: .circular)
          //trim edge
            .trim(from: 0.61,to: 0.64)
            .stroke(style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin:.round))
            .rotationEffect(.init(degrees: 90))
          RoundedRectangle(cornerRadius: 2, style: .circular)
          //trim edge
            .trim(from: 0.61,to: 0.64)
            .stroke(style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin:.round))
            .rotationEffect(.init(degrees: 180))
          RoundedRectangle(cornerRadius: 2, style: .circular)
          //trim edge
            .trim(from: 0.61,to: 0.64)
            .stroke(style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin:.round))
            .rotationEffect(.init(degrees: 270))

        }
        //square shape
        .frame(width: size.width, height: size.width)
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
}

#Preview {
  ScannerView()
}
