import AVFAudio
import Foundation

struct _PlayerSession {
    private var audioPlayer: FDAAudioPlayer!
}

extension _PlayerSession: PlayerSession {
    var isPlaying: Bool {
        audioPlayer?.isPlaying
        ?? false
    }

    mutating func start(directory: URL,
                        delegate: AVAudioPlayerDelegate) throws {
        audioPlayer = try? AVAudioPlayer(contentsOf: directory)
        audioPlayer.delegate = delegate
        audioPlayer?.isMeteringEnabled = true
        audioPlayer?.play()
    }

    func stop() {
        audioPlayer?.stop()
    }
}

