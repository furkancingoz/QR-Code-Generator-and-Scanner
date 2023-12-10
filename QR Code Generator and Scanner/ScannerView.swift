//
//  ScannerView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI
import AVKit

struct ScannerView: View {

  //qecode scanner properties
  @State private var isScanning : Bool = false
  @State private var session : AVCaptureSession = .init()
  @State private var cameraPermission : Permission = .idle

  //SCANER OUT PUT
  @State private var qrOutput : AVCaptureMetadataOutput = .init()

  //ERROR PROP.
  @State private var errorMessages : String = ""
  @State private var showError : Bool = false

  //settings
  @Environment(\.openURL) private var openURL

  @StateObject private var qrDelegate  = QRScannerDelegate()

  @State private var scannedCode : String = ""
  var body: some View {
    VStack{

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
          CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
            .scaleEffect(0.97)
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

      Text(scannedCode.isEmpty ? "No QR Code Detected" : scannedCode)
          .font(.title3)
          .foregroundColor(.white.opacity(0.8))
          .padding()
          .contextMenu {
              Button(action: {
                  UIPasteboard.general.string = scannedCode
              }) {
                  Text("Copy to Clipboard")
                  Image(systemName: "doc.on.doc")
              }
          }

      Button{
        //action
        if !session.isRunning && cameraPermission == .approved {
          reactiveCamera()
          activateScannerAnimation()
        }
      } label: {
        Image(systemName: "qrcode.viewfinder")
          .font(.largeTitle)
          .foregroundColor(.gray)
      }
      .padding(.bottom,50)

      Spacer(minLength: 45)
    }
    .padding(15)
    //check camera permison but when view is visible
    .onAppear(perform: {
      checkCameraPermission()
    })
    .alert(errorMessages, isPresented: $showError) {
      if cameraPermission == .denied {
        Button("Settings"){
          let settingsString = UIApplication.openSettingsURLString
          if let settingsURL = URL(string: settingsString){
            openURL(settingsURL)
          }
        }

        Button("Cancel", role: .cancel){

        }
      }
    }
    .onChange(of: qrDelegate.scannedCode) { newValue in
      if let code = newValue {
        scannedCode = code
        session.stopRunning()
        deactivateScannerAnimation()
        // clearing the data on delegate
        qrDelegate.scannedCode = nil
      }
    }
  }

  func reactiveCamera() {
    DispatchQueue.global(qos: .background).async {
      if session.isRunning {
        session.stopRunning()
      }
      session.startRunning()
    }
  }

  //activation scanner animation method
  func activateScannerAnimation(){
    withAnimation(.easeOut(duration: 0.80).delay(0.1).repeatForever(autoreverses: true)) {
      isScanning = true
    }
  }
  //de- activation scanner animation method
  func deactivateScannerAnimation(){
    withAnimation(.easeOut(duration: 0.80)) {
      isScanning = false
    }
  }

  //CHECK THE CAMERA PERMISSON
  func checkCameraPermission(){
    Task{
      switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized:
        cameraPermission = .approved
        if session.inputs.isEmpty {
          setupCamera()
        } else {
          //already existing one
          self.session.startRunning()
        }
      case .notDetermined:
        if await AVCaptureDevice.requestAccess(for: .video) {
          cameraPermission = .approved
          setupCamera()
        } else {
          cameraPermission = .denied
          presentError("Please Provide Access to Camera for scanning codes")
        }
      case .denied,.restricted:
        cameraPermission = .denied
        presentError("Please Provide Access to Camera for scanning codes")
      default : break
      }
    }

    //setup
    func setupCamera(){
      do{
        //find back camera
        guard let  device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
          presentError("UNKNOW DEVICE ERROR")
          return
        }


        //camera input
        let input = try AVCaptureDeviceInput(device: device)
        //extra safety
        //check
        guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
          presentError("UNKNOW INPUT OUTPUT ERROR")
          return
        }

        //addin input and output camera session
        session.beginConfiguration()
        session.addInput(input)
        session.addOutput(qrOutput)
        qrOutput.metadataObjectTypes = [.qr]

        qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
        session.commitConfiguration()
        DispatchQueue.global(qos: .background).async {
          session.startRunning()
        }
        activateScannerAnimation()
      } catch {

      }
    }

    //present Error
    func presentError(_ message : String){
      errorMessages = message
      showError.toggle()
    }
  }
}
#Preview {
  ScannerView()
}
