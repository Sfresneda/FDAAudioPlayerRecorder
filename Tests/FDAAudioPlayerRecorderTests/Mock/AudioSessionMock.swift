import Foundation
@testable import FDAAudioPlayerRecorder

final class AudioSessionMock {
    var _permission: FDAPermissionStatus = .unknown
}
extension AudioSessionMock: MicrophonePermissionSession {
    var permission: FDAPermissionStatus {
        _permission
    }
    
    func requestPermission(completionHandler response: @escaping (Bool) -> Void) {
        response(_permission == .granted)
    }
}
