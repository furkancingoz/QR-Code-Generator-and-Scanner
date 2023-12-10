//
//  QRScannerDelegate.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 11.12.2023.
//

import SwiftUI
import AVKit

class QRScannerDelegate: NSObject,ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
  @Published var scannedCode : String?
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metaObject = metadataObjects.first {
      guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let Code =  readableObject.stringValue else { return }

      scannedCode = Code
    }
  }
}

