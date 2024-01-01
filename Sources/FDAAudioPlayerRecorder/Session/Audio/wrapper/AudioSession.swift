import AVFAudio
import Foundation

protocol AudioSession {
    mutating func start(session: FDAAudioSession) throws
    func stop() throws
    func setAudioOutput(_ isSpeakerActive: Bool) throws
}
