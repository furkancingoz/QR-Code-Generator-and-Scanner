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
  @State private var startAnimation: Bool = false
  var body: some View {
    VStack {
      Image(uiImage: QRCodeImage!)
          .resizable()
          .frame(width: 200, height: 200)
          .cornerRadius(5)
          .shadow(color: .gray, radius: 5)
          .scaleEffect(startAnimation ? 1 : 0.8)
          .onAppear {
              withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                  startAnimation = true
              }
          }
          .background(
              Image("paperTexture")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
          )
      Text("\(text)")
        .padding()

    }
  }
}
struct ContentView: View {
  @State private var text  = ""
  @State private var QRCodeImage : UIImage?
  @State private var startAnimation: Bool = false
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          .purple,
          .blue],
        startPoint: startAnimation ? .topLeading : .bottomLeading,
        endPoint: startAnimation ? .bottomTrailing : .topTrailing
      )
      .onAppear {
        withAnimation(.linear(duration: 5.0).repeatForever()) {
          startAnimation.toggle()
        }
      }
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
