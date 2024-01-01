import AVFAudio
import Foundation
@testable import FDAAudioPlayerRecorder

final class AudioSessionSpy {
    var setCategorySpy: Bool = false
    var setActiveSpy: Bool = false
    var overrideOutputAudioPortSpy: Bool = false
}
extension AudioSessionSpy: FDAAudioSession {
    static func shared() -> FDAAudioSession {
        Self()
    }
    
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {
        setCategorySpy.toggle()
    }
    
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws {
        setActiveSpy.toggle()
    }
    
    func overrideOutputAudioPort(_ portOverride: AVAudioSession.PortOverride) throws {
        overrideOutputAudioPortSpy.toggle()
    }
    

}
