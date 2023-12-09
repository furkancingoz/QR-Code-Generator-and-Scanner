//
//  ContentView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 8.12.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit

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
        .onTapGesture {
                        hideKeyboard()
                    }
    )
  }
  func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
struct QRGenerateView: View {
  @State private var text  = ""
  @State private var buttonText = ""
  @State private var QRCodeImage : UIImage?
  @State private var startAnimation: Bool = false
  @State private var showAlert = false
  let gradientColors = Gradient(colors: [.indigo, .orange])
  public init() {}

  var body: some View {

    NavigationView {
      ZStack {

        LinearGradient(
          colors: [
            .orange,
            .cyan],
          startPoint: startAnimation ? .topLeading : .bottomTrailing,
          endPoint: startAnimation ? .bottomLeading : .topLeading
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
            .fontWeight(.heavy)
          TextField("Enter Text", text: $text)
            .font(.headline)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding()

          Button("Generator QR Code"){
            QRCodeImage = UIImage(data: generatorQRCode(text: text)!)!
            hideKeyboard()
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
              guard let renderedImage = ImageRenderer(content: QRCodeView(QRCodeImage: $QRCodeImage, text: $text)).uiImage
              else { return }
              DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(renderedImage, coordinator, #selector(Coordinator.image(_:didFinishSavingWithError:contextInfo:)), nil)
              }

              showAlert = true
            }
            .font(.headline)
            .foregroundStyle(.primary)
            .buttonStyle(.bordered)
            .clipShape(Capsule())
            .padding()
            .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Save"),
                                message: Text("QR Code successfully saved."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                     }

          Spacer()
          //MARK: -  BANNER VİEW
        }
        
            }.navigationBarItems(trailing: Button(action: {
              requestToRate()
          }) {
              Image(systemName: "star") // Sistem yıldız ikonu
                  .resizable()
                  .frame(width: 25, height: 25) // İkon boyutunu ayarla
          })
            .ignoresSafeArea(.all)
      }
}




  //MARK: - FUNC
  func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  func requestToRate() {
      SKStoreReviewController.requestReview()
  }
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
class Coordinator: NSObject {
    var onSave: ((Bool) -> Void)?

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            onSave?(false)
        } else {
            print("QR Code Saved to Photos")
            onSave?(true)
        }
    }
}
#Preview {
  QRGenerateView()
}
