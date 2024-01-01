import Foundation
import AVFAudio

/// Microphone permission service.
protocol MicrophonePermissionSession {

    /// The current permission status.
    var permission: FDAPermissionStatus { get }

    /// Request the permission.
    /// - Parameter response: the response handler
    func requestPermission(completionHandler response: @escaping (Bool) -> Void)
}

@available(iOS 17.0, *)
extension AVAudioApplication: MicrophonePermissionSession {
    var permission: FDAPermissionStatus {
        FDAPermissionStatus(Self.shared.recordPermission)
    }

    func requestPermission(completionHandler response: @escaping (Bool) -> Void) {
        Self.requestRecordPermission(completionHandler: response)
    }
}
extension AVAudioSession: MicrophonePermissionSession {
    var permission: FDAPermissionStatus {
        FDAPermissionStatus(Self.sharedInstance().recordPermission)
    }

    func requestPermission(completionHandler response: @escaping (Bool) -> Void) {
        Self.sharedInstance().requestRecordPermission(response)
    }
}

