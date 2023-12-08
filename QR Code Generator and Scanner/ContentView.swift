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
        .frame(width: 300, height: 300)
        .cornerRadius(5)
        .shadow(color: .gray, radius: 5)
        .scaleEffect(startAnimation ? 1 : 0.6)
        .onAppear {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
            startAnimation = true
          }

        }.padding()

      Text("\(text)")
        .foregroundColor(.white)
        .padding()

    }.background(
      Image("paperTexture")
        .resizable()
        .aspectRatio(contentMode: .fill)

    )
  }
}
struct ContentView: View {
  @State private var text  = ""
  @State private var QRCodeImage : UIImage?
  @State private var startAnimation: Bool = false
  let gradientColors = Gradient(colors: [.blue, .white])

  var body: some View {
    ZStack {
      LinearGradient(
                  gradient: gradientColors,
                  startPoint: startAnimation ? .topLeading : .bottomLeading,
                  endPoint: startAnimation ? .bottomTrailing : .topTrailing
              )
      .onAppear {
        withAnimation(.linear(duration: 20.0).repeatForever()) {
          startAnimation.toggle()
        }
      }
      VStack{
        Spacer()
        Text("QR Code Generator")
          .font(.largeTitle)
              .padding()
              .background(Color.blue) // Arkaplan rengini istediğiniz bir renkle değiştirebilirsiniz
              .foregroundColor(Color.black) // Metin rengini değiştirebilirsiniz
              .cornerRadius(10)
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

        var coordinator = Coordinator()

        if QRCodeImage != nil {
          QRCodeView(QRCodeImage: $QRCodeImage, text: $text)

          Button("Save QR Code to Photos") {
                     guard let renderedImage = ImageRenderer(content: QRCodeView(QRCodeImage: $QRCodeImage, text: $text)).uiImage else { return }
                     DispatchQueue.main.async {
                         UIImageWriteToSavedPhotosAlbum(renderedImage, coordinator, #selector(Coordinator.image(_:didFinishSavingWithError:contextInfo:)), nil)
                     }
                 }
          .font(.headline)
          .foregroundStyle(.primary)
          .buttonStyle(.bordered)
          .clipShape(Capsule())
          .padding()

        }



        Spacer()
        //MARK: -  BANNER VİEW

      }
    }.ignoresSafeArea(.all)
  }
  //MARK: - FUNC
  func generatorQRCode(text: String) -> Data? {
      let filter = CIFilter.qrCodeGenerator()
      guard let data = text.data(using: .utf8, allowLossyConversion: false) else {
          return nil
      }

      filter.message = data

      guard let ciImage = filter.outputImage else { return nil }
      let transform = CGAffineTransform(scaleX: 12, y: 12) // Ölçeklendirme faktörünü artırabilirsiniz.
      let scaledCIImage = ciImage.transformed(by: transform)

      let context = CIContext(options: nil)
      guard let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else {
          return nil
      }

      let uiImage = UIImage(cgImage: cgImage)
      return uiImage.jpegData(compressionQuality: 1.0) // PNG yerine yüksek kaliteli JPEG kullanın.
  }
}
class Coordinator: UIViewController {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("QR Code Saved to Photos")
        }
    }
}
#Preview {
  ContentView()
}
