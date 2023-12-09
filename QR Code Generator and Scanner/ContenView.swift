//
//  ContenView.swift
//  QR Code Generator and Scanner
//
//  Created by Furkan Cingöz on 9.12.2023.
//

import SwiftUI

struct OnboardingStep {
  let image: String
  let title: String
  let desc: String
}

private let onboardingSteps = [
  OnboardingStep(image: "qrcode", title: "Create a QR Code", desc: "easily create your qr code"),
  OnboardingStep(image: "clock", title: "Feature", desc: "Qr code scanning feature will be added very soon"),
  OnboardingStep(image: "square.and.arrow.down.on.square.fill", title: "Save the QR Code", desc: "You can save the qr codes you create as a image.")]


struct ContenView: View {
  @State private var isActive: Bool = false
  @State private var showQRGenerate = false // QRGenerate ekranını göstermek için kullanılan bir state
  
  
  @State private var currentStep = 0
  
  
  init() {
    UIScrollView.appearance().bounces = false
  }
  @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
  @Environment(\.dismiss) var dismiss
  @State var isPressed: Bool = false
  
  var body: some View {
    if isWelcomeScreenOver {
      QRGenerateView()
    } else {
      
      
      
      
      NavigationView {
        VStack{
          HStack{
            Spacer()
            Button(action: {
              
              self.showQRGenerate = true
              self.isWelcomeScreenOver = true
            }, label: {
              Text("Skip")
                .padding()
                .foregroundColor(.gray)
            })
          }
          
          
          
          
          TabView(selection: $currentStep){
            ForEach(0..<onboardingSteps.count){ items in
              VStack{
                Image(systemName: onboardingSteps[items].image)
                  .resizable()
                  .frame(width: 350,height: 350)
                  .foregroundStyle(.primary)
                
                
                Text(onboardingSteps[items].title)
                  .font(.title)
                  .bold()
                
                Text(onboardingSteps[items].desc)
                  .font(.subheadline)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal,32)
                
              }
              .tag(items)
            }
          }
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
          
          HStack {
            ForEach(0..<onboardingSteps.count){ item in
              if item == currentStep {
                Rectangle()
                  .frame(width: 20,height: 10)
                  .cornerRadius(10)
                  .foregroundColor(.blue)
              } else {
                Circle()
                  .frame(width: 10,height: 10)
                  .foregroundColor(.gray)
              }
            }
          }
          .padding(.bottom,25)
          
          Button(action:{
            if self.currentStep < onboardingSteps.count - 1 {
              self.currentStep += 1
            } else {
              self.isActive = true
              isPressed = true
              isWelcomeScreenOver = true// Ekleme: Get Started'a basıldığında QRGenerate ekranını göster
            }
          }) {
            Text(currentStep < onboardingSteps.count - 1 ? "Next" : "Get Started")
              .padding(15)
              .frame(maxWidth: .infinity)
              .background(Color.blue)
              .cornerRadius(16)
              .padding(.horizontal,16)
              .foregroundColor(.white)
          }.background(NavigationLink(destination: QRGenerateView().navigationBarHidden(true), isActive: $isActive) { EmptyView() }.hidden())
          
        }
      }
    }
  }
}


#Preview {
  ContenView()
}
