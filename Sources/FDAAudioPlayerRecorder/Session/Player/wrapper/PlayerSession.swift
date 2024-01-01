import AVFAudio
import Foundation

protocol PlayerSession {
    var isPlaying: Bool { get }
    mutating func start(directory: URL,
                        delegate: AVAudioPlayerDelegate) throws
    func stop()
}
