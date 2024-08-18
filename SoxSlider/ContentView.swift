import AVFoundation
import SwiftUI

struct ContentView: View {
  @State private var sliderValue: Double = 1.0
  @State private var statusText: String = "Not running"
  @EnvironmentObject var shared: SharedData

  var body: some View {
    VStack(spacing: 20) {
      Text("Sox Slider")
        .font(.largeTitle)

      HStack {
        Text("\(String(format: "%.0f", sliderValue * 100))%")
        Slider(
          value: $sliderValue, in: 0.0...3.0, step: 0.1,
          onEditingChanged: { editing in
            if isRunning() && !editing {
              // Restart sox to apply volume modification
              stopSox()
              startSox()
            }
          })
      }
      .padding()

      HStack {
        Button(action: startSox) {
          Text("Start")
            .frame(width: 80, height: 40)
            .background(isRunning() ? Color.gray : Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .disabled(isRunning())

        Button(action: stopSox) {
          Text("Stop")
            .frame(width: 80, height: 40)
            .background(isRunning() ? Color.red : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .disabled(!isRunning())
      }

      Text(statusText)
    }
    .padding()

  }

  func startSox() {

    if isRunning() {
      print("Already running")
      return
    }

    if !shared.gotPermission {
      statusText = "No microphone permission"
      return
    }

    let volumeValue = String(format: "%.1f", sliderValue)

    if let soxPath = Bundle.main.path(forResource: "sox", ofType: nil, inDirectory: nil) {

      // "chmod +x" sox
      let fileManager = FileManager.default
      if let soxPath = Bundle.main.path(forResource: "sox", ofType: nil, inDirectory: "Binaries") {
        try? fileManager.setAttributes([.posixPermissions: 0o755], ofItemAtPath: soxPath)
      }

      let soxProcess = Process()
      soxProcess.executableURL = URL(fileURLWithPath: soxPath)
      soxProcess.arguments = [
        "-v", volumeValue,
        "-V0",  // settings for low latency
        "--multi-threaded",
        "--input-buffer", "32",
        "--buffer", "128",
        "-d", "-d",  // default audio out, default audio in
        "-q",  // quiet mode
      ]

      do {
        try soxProcess.run()

        statusText = "Running..."
        shared.soxProcess = soxProcess

      } catch {
        print("Failed to start Sox process")
      }
    } else {
      print("Sox binary not found in app bundle.")
    }
  }

  func stopSox() {
    shared.soxProcess?.terminate()
    shared.soxProcess = nil
    statusText = "Not running"
  }

  func isRunning() -> Bool {
    return shared.soxProcess != nil
  }

}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
