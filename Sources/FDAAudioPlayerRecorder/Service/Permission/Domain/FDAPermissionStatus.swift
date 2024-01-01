import Foundation
import AVFAudio

/// Microphone permission service.
public enum FDAPermissionStatus {

    /// The permission is granted.
    case granted

    /// The permission is denied.
    case denied

    /// The permission is undetermined.
    case undetermined

    /// Otherwise.
    case unknown

    @available(iOS 17.0, *)
    init(_ state: AVAudioApplication.recordPermission) {
        switch state {
        case .denied:
            self = .denied
        case .granted:
            self = .granted
        case .undetermined:
            self = .undetermined
        @unknown default:
            self = .unknown
        }
    }

    init(_ state: AVAudioSession.RecordPermission) {
        switch state {
        case .granted:
            self = .granted
        case .denied:
            self = .denied
        case .undetermined:
            self = .undetermined
        @unknown default:
            self = .unknown
        }
    }
}
