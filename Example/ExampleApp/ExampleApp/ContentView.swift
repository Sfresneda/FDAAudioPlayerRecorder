//
//  ContentView.swift
//  ExampleApp
//
//  Created by Sergio Fresneda González on 29/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model: ContentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(model.files) { file in
                    HStack {
                        Button("", 
                               systemImage: "play.fill") {
                            model.play(file: file)
                        }
                        Text(file.sortName)
                    }
                }
            }
            if model.arePermissionGranted {
                grantedPermissionItems()
            } else {
                nonGrantedPermissionItems()
            }
        }
    }
}

private extension ContentView {
    func grantedPermissionItems() -> some View {
        VStack {
            Button(model.primaryButtonTitle) {
                model.doPrimaryAction()
            }
            Text("Peak value: \(model.peakValue)")
        }
    }
    func nonGrantedPermissionItems() -> some View {
        switch model.permissionState {
        case .undetermined:
            return Button("Allow microphone permission") {
                Task { await model.askForPermission() }
            }
            
        default:
            return Button("Go to settings to set microphone permission") {
                Task {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(settingsUrl) else {
                        return
                    }
                    
                    await UIApplication.shared.open(settingsUrl)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
