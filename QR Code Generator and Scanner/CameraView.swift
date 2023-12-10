//
//  CameraView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 10.12.2023.
//

import SwiftUI
import AVKit

//camera using avcapture
struct CameraView: UIViewRepresentable {
  var frameSize : CGSize
  ///camera session
  @Binding var session : AVCaptureSession
  func makeUIView(context: Context) -> UIView {
    let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
    view.backgroundColor = .clear

    let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
    cameraLayer.frame = .init(origin: .zero, size: frameSize)
    cameraLayer.videoGravity = .resizeAspectFill
    cameraLayer.masksToBounds = true
    view.layer.addSublayer(cameraLayer)
    return view
  }


  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
}

