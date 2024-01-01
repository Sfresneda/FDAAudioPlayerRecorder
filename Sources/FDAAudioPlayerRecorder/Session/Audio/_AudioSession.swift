import AVFAudio
import Foundation

struct _AudioSession {
    private var audioSession: FDAAudioSession!
}

extension _AudioSession: AudioSession {
    mutating func start(session: FDAAudioSession = AVAudioSession.sharedInstance()) throws {
        audioSession = session
        
        try audioSession?.setCategory(.playAndRecord, mode: .default, options: [])
        try audioSession?.setActive(true, options: [])
    }
    
    func stop() throws {
        try audioSession?.setActive(false, options: [])
    }
    
    func setAudioOutput(_ isSpeakerActive: Bool) throws {
        let output: AVAudioSession.PortOverride = isSpeakerActive
        ? .speaker
        : .none
        
        try audioSession?.overrideOutputAudioPort(output)
    }
}
