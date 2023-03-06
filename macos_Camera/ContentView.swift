//
//  ContentView.swift
//  macos_Camera
//
//  Created by Peter Rogers on 06/03/2023.
//

import SwiftUI
import Vision

struct ContentView: View {
    
    @State private var score:[VNBarcodeObservation] = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            CameraView{
                score = $0
            }.overlay(
                RepresentedImageView(score: $score)
                    .foregroundColor(.red)
              )        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
