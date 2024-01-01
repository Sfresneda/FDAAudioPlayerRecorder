import AVFAudio
import Foundation

protocol FDAAudioSession {
    static func shared() -> FDAAudioSession

    func setCategory(_ category: AVAudioSession.Category,
                     mode: AVAudioSession.Mode,
                     options: AVAudioSession.CategoryOptions) throws
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws
    func overrideOutputAudioPort(_ portOverride: AVAudioSession.PortOverride) throws
}

extension AVAudioSession: FDAAudioSession {
    static func shared() -> FDAAudioSession {
        Self.sharedInstance()
    }
}
