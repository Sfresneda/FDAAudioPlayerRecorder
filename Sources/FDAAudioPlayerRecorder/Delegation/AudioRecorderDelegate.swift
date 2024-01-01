import AVFAudio
import Foundation

/// Audio recorder delegate.
final class AudioRecorderDelegate: NSObject {

    /// The error.
    @Published var error: Error?

    /// The completion block that will be called when the recorder finish recording.
    var didFinishCompletion: ((Bool) -> Void)? {
        willSet {
            if nil != newValue {
                didFinishPassiveCompletion = nil
            }
        }
    }

    /// The completion block that will be called when the recorder finish recording by itself.
    var didFinishPassiveCompletion: ((Bool) -> Void)? {
        willSet {
            if nil != newValue {
                didFinishCompletion = nil
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorderDelegate: AVAudioRecorderDelegate {

    /// audioRecorderEncodeErrorDidOccur is called when an error occurred while encoding the audio data.
    /// - Parameters:
    /// - recorder: the recorder
    /// - error: the error
    public func audioRecorderEncodeErrorDidOccur(
        _ recorder: AVAudioRecorder,
        error: Error?) {
            self.error = error
        }

    /// audioRecorderDidFinishRecording is called when a recording has finished.
    /// - Parameters:
    /// - recorder: the recorder
    /// - flag: true if the recording successfully, false otherwise
    public func audioRecorderDidFinishRecording(
        _ recorder: AVAudioRecorder,
        successfully flag: Bool) {
            if nil != didFinishCompletion {
                didFinishCompletion?(flag)
            } else {
                didFinishPassiveCompletion?(flag)
            }
        }
}

