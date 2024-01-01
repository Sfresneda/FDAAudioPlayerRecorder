import AVFAudio
import Foundation

struct _RecorderSession {
    private var audioRecorder: AVAudioRecorder!
    private let peakTimerManager: PeakTimerManager = PeakTimerManager()
}

extension _RecorderSession: RecorderSession {
    var isRecording: Bool {
        audioRecorder?.isRecording
        ?? false
    }
    
    mutating func start(directory: URL,
                        recordingSettings: [String: Any],
                        peakCallback: PeakUpdateResponse?,
                        delegate: AVAudioRecorderDelegate) throws {
        do {
            audioRecorder = try AVAudioRecorder(url: directory,
                                                settings: recordingSettings)
        } catch {
            stop()
            throw error
        }
        audioRecorder?.delegate = delegate
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()

        setupAndRunPeakTimer(peakCallback)
    }

    mutating func stop() {
        stopTimer()
        audioRecorder?.stop()
    }
}

private extension _RecorderSession {
    mutating func setupAndRunPeakTimer(_ completion: PeakUpdateResponse?) {
        peakTimerManager.start { [audioRecorder] _ in
            let peak = audioRecorder?.peakPower(forChannel: .zero)
            ?? .zero
            let average = audioRecorder?.averagePower(forChannel: .zero)
            ?? .zero

            completion?((peak, average))

            audioRecorder?.updateMeters()
        }
    }

    mutating func stopTimer() {
        peakTimerManager.stop()
    }
}
