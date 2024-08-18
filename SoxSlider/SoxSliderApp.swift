//
//  SoxSliderApp.swift
//  SoxSlider
//
//  Created by David Silverlind on 2024-08-18.
//

import AVFoundation
import SwiftUI

class SharedData: ObservableObject {
  @Published var soxProcess: Process?
  @Published var gotPermission = false
}

@main
struct SoxSliderApp: App {

  @StateObject private var shared = SharedData()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(shared)
        .onAppear {
          triggerMicPermissionRequest()
        }
        .onExitCommand(perform: {
          print("I will die")
        })
        .onDisappear(perform: {

          print("Disappearing")
          shared.soxProcess?.terminate()
          shared.soxProcess = nil
        })
    }

  }

  private func triggerMicPermissionRequest() {
    checkOrRequestMicrophone { granted in
      DispatchQueue.main.async {
        if granted {
          print("Microphone access granted.")
          shared.gotPermission = true
        } else {
          print("Microphone access denied.")
          shared.gotPermission = false
        }
      }
    }
  }

}

func checkOrRequestMicrophone(completion: @escaping (Bool) -> Void) {
  switch AVCaptureDevice.authorizationStatus(for: .audio) {
  case .authorized:
    // already got permission
    completion(true)
  case .notDetermined:
    // request
    AVCaptureDevice.requestAccess(for: .audio) { granted in
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  case .denied, .restricted:
    // denied
    completion(false)
  @unknown default:
    // whatever
    completion(false)
  }
}
