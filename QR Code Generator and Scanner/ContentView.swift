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
      LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
      VStack{
        Spacer()
        Text("QR Code Generator")
          .font(.largeTitle)
          .padding()
        TextField("Enter Text", text: $text)
          .font(.headline)
          .padding()
          .background(.ultraThinMaterial)
          .clipShape(Capsule())
          .padding()

        Button("Generator QR Code"){
          QRCodeImage = UIImage(data: generatorQRCode(text: text)!)!
        }
        .font(.headline)
        .foregroundStyle(.primary)
        .buttonStyle(.bordered)
        .clipShape(Capsule())
        .padding()

        if QRCodeImage != nil {
          QRCodeView(QRCodeImage: $QRCodeImage, text: $text)

          Button("Save QR Code to Photos"){
            guard let renderedIamge = ImageRenderer(content: QRCodeView(QRCodeImage: $QRCodeImage, text: $text)).uiImage else{ return
            }
            UIImageWriteToSavedPhotosAlbum(renderedIamge, nil, nil, nil)
          }
        }
          else {
          
        }

        Spacer()
        //MARK: -  BANNER VİEW

      }
    }.ignoresSafeArea(.all)
  }
  func generatorQRCode(text:String) -> Data? {
    let filter = CIFilter.qrCodeGenerator()

    guard let data = text.data(using: .ascii,allowLossyConversion: false) else {
      return nil
    }

    filter.message = data

    guard let ciimage = filter.outputImage else { return nil }
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledImage = ciimage.transformed(by: transform)
    let uiimage = UIImage(ciImage: scaledImage)
    return uiimage.pngData()!
  }
}
  #Preview {
    ContentView()
  }
