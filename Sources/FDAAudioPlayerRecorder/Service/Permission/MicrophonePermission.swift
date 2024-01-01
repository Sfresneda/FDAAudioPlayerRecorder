import Foundation
import AVFAudio

/// Microphone permission service.
public protocol MicrophonePermission {

    /// The current permission status.
    var status: FDAPermissionStatus { get }

    /// The permission is granted.
    var arePermissionGranteed: Bool { get }

    /// Request the permission.
    func askForPermission() async -> Bool
}

struct _MicrophonePermission: MicrophonePermission {
    private(set) var microphoneInstance: MicrophonePermissionSession

    init(instance: MicrophonePermissionSession) {
        self.microphoneInstance = instance
    }

    public var status: FDAPermissionStatus {
        microphoneInstance.permission
    }

    public var arePermissionGranteed: Bool {
        status == .granted
    }

    public func askForPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            microphoneInstance.requestPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }
    }
}

extension _MicrophonePermission {

    /// The shared instance. If iOS 17.0 or above, AVAudioApplication.shared is 
    /// used, otherwise AVAudioSession.sharedInstance().
    static var shared: _MicrophonePermission {
        if #available(iOS 17.0, *) {
            Self.init(instance: AVAudioApplication.shared)
        } else {
            Self.init(instance: AVAudioSession.sharedInstance())
        }
    }
}
