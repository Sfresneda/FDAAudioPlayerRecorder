import AVFAudio
import Foundation

/// Audio player delegate.
final class AudioPlayerDelegate: NSObject {

    /// The error.
    @Published var error: Error?

    /// The completion block that will be called when the player finish playing.
    var didFinishCompletion: ((Bool) -> Void)? {
        willSet {
            if nil != newValue {
                didFinishPassiveCompletion = nil
            }
        }
    }

    /// The completion block that will be called when the player finish playing by itself.
    var didFinishPassiveCompletion: ((Bool) -> Void)? {
        willSet {
            if nil != newValue {
                didFinishCompletion = nil
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerDelegate: AVAudioPlayerDelegate {

    /// audioPlayerDecodeErrorDidOccur is called when an error occurred while decoding the audio data.
    /// - Parameters:
    ///  - player: the player
    /// - error: the error
    public func audioPlayerDecodeErrorDidOccur(
        _ player: AVAudioPlayer,
        error: Error?) {
            self.error = error
        }

    /// audioPlayerDidFinishPlaying is called when a sound has finished playing.
    /// - Parameters:
    /// - player: the player
    /// - flag: true if the playback reached the end of the audio file, false if the playback stopped
    public func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool) {
            if nil != didFinishCompletion {
                didFinishCompletion?(flag)
            } else {
                didFinishPassiveCompletion?(flag)
            }
        }

}
