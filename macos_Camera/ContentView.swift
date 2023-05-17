//
//  ContentView.swift
//  macos_Camera
//
//  Created by Peter Rogers on 06/03/2023.
//

import SwiftUI
import Vision
import Combine

struct ContentView: View {
   // @StateObject var sentence = SentenceCreator()
    
    @StateObject private var viewModel = MyModel()
    var body: some View {
        
            VStack {
                CameraView{
                    
                    viewModel.score = $0
                }.overlay(
                    Group {
                        if viewModel.sentence.isLoading {
                            ProgressView("Waiting For the AI")            .colorInvert() /// make the spinner a semi-opaque white
                                .brightness(1) /// ramp up the brightness
                                .padding()
                                .background(.black)
                                .cornerRadius(10)
                        }
                    }
                    )
                //Text(sentence.sentences)
                Text(viewModel.sentence.story).fontWeight(.bold)
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .multilineTextAlignment(.leading)
                
                Button("click to make story"){
                    print("Button tapped!")
                    // let jsonReader = JSONReader()
                    // jsonReader.makeQuery()
                
                    
                }.niceButton(
                    foregroundColor: .white,
                    backgroundColor: .mint,
                    pressedColor: .orange
                    )
                .disabled(viewModel.sentence.isLoading)
                
            }.padding(50)
            
          
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(6.0)
            .padding()
    }
}

extension View {
  func niceButton(
    foregroundColor: Color = .white,
    backgroundColor: Color = .gray,
    pressedColor: Color = .accentColor
  ) -> some View {
    self.buttonStyle(
      NiceButtonStyle(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        pressedColor: pressedColor
      )
    )
  }
}

struct NiceButtonStyle: ButtonStyle {
  var foregroundColor: Color
  var backgroundColor: Color
  var pressedColor: Color

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.headline)
      .padding(10)
      .foregroundColor(foregroundColor)
      .background(configuration.isPressed ? pressedColor : backgroundColor)
      .cornerRadius(5)
  }
}


