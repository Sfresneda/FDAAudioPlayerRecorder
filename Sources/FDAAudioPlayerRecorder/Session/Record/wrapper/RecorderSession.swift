import AVFAudio
import Foundation

typealias PeakUpdateResponse = (((peak: Float, average: Float)) -> Void)

protocol RecorderSession {
    var isRecording: Bool { get }
    mutating func start(directory: URL,
                        recordingSettings: [String: Any],
                        peakCallback: PeakUpdateResponse?,
                        delegate: AVAudioRecorderDelegate) throws
    mutating func stop()
}
