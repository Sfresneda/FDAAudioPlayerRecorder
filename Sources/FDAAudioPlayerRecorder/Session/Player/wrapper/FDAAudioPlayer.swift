import AVFAudio
import Foundation

protocol FDAAudioPlayer {
    var isPlaying: Bool { get }
    var delegate: AVAudioPlayerDelegate? { get set }
    var isMeteringEnabled: Bool { get set }

    init(contentsOf url: URL) throws
    @discardableResult func play() -> Bool
    func stop()
}

extension AVAudioPlayer: FDAAudioPlayer {}
