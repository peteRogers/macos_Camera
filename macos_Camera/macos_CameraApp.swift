//
//  macos_CameraApp.swift
//  macos_Camera
//
//  Created by Peter Rogers on 06/03/2023.
//

import SwiftUI

@main
struct macos_CameraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onDisappear{
                    terminateApp()
                }
        }
    }
    
    private func terminateApp() {
           NSApplication.shared.terminate(self)
       }
}
