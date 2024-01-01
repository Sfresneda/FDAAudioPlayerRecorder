import Foundation
import AVFAudio

/// FDAudioPlayerRecorder, a wrapper for AVAudioSession, AVAudioRecorder and AVAudioPlayer
public final class FDAAudioPlayerRecorder: NSObject {

    /// Publishers for the audio player and recorder.
    public var publishers = AudioPlayerRecorderPublishers()

    /// The current file directory.
    public private(set) var currentFileDirectory: URL?

    private var audioSession: AudioSession?
    private var recorderSession: RecorderSession?
    private var playerSession: PlayerSession?

    private var playerDelegate: AudioPlayerDelegate = AudioPlayerDelegate()
    private var recorderDelegate: AudioRecorderDelegate = AudioRecorderDelegate()

    private let localAudioSettings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    public override init() {}
}

// MARK: - General
public extension FDAAudioPlayerRecorder {

    /// Microphone permission service.
    static let microphonePermission: MicrophonePermission = _MicrophonePermission.shared

    /// setAudioSpeaker allow to set the audio output to the speaker.
    /// - Parameter value: true if you want to play the audio on the speaker, false otherwise
    func setAudioSpeaker(_ value: Bool) {
        do {
            try audioSession?.setAudioOutput(value)
            publishers.isSpeakerActive = .init(value: value)
        } catch {
            // Silent is golden
        }
    }
}

// MARK: - Recorder
public extension FDAAudioPlayerRecorder {

    /// isRecording return true if the recorder is recording, false otherwise.
    var isRecording: Bool {
        recorderSession?.isRecording
        ?? false
    }

    /// startRecording start the recording session.
    /// - Parameters:
    ///  - session: the audio session, default is AVAudioSession.sharedInstance()
    /// - recordingSettings: the recording settings, default is nil
    /// - Throws: throw an error if the recording session can't be started.
    func startRecording(session: AVAudioSession = AVAudioSession.sharedInstance(),
                        recordingSettings: [String: Any]? = nil) throws {

        defer {
            recorderDelegate.didFinishPassiveCompletion = { [weak self] _ in
                self?.publishers.currentState = .init(value: .pause)
            }
        }

        audioSession = _AudioSession()
        try audioSession?.start(session: session)

        let directory = try FileDirectoryManager.getFileUrl()

        recorderSession = _RecorderSession()

        let settings = recordingSettings ?? localAudioSettings
        try recorderSession?.start(directory: directory,
                                    recordingSettings: settings,
                                    peakCallback: { [weak self] (peak,_) in
            self?.publishers.peakValue = .init(value: peak)
        }, delegate: recorderDelegate)

        currentFileDirectory = directory
        publishers.currentState = .init(value: .recording)
    }

    /// stopRecording stop the recording session.
    /// - Throws: throw an error if the recording session can't be stopped.
    func stopRecording() async throws -> Bool {
        guard true == recorderSession?.isRecording else {
            publishers.currentState = .init(value: .pause)
            return false
        }

        return await withCheckedContinuation { continuation in
            recorderDelegate.didFinishCompletion = { [weak self] result in
                self?.publishers.currentState = .init(value: .pause)
                continuation.resume(returning: result)
            }

            Task { [weak self] in
                self?.recorderSession?.stop()
                self?.recorderSession = nil

                try self?.audioSession?.stop()
                self?.audioSession = nil
            }
        }
    }
}

// MARK: - Player
public extension FDAAudioPlayerRecorder {

    /// isPlaying return true if the player is playing, false otherwise.
    var isPlaying: Bool {
        playerSession?.isPlaying
        ?? false
    }

    /// startPlaying start the playing session.
    /// - Parameters:
    /// - session: the audio session, default is AVAudioSession.sharedInstance()
    /// - url: the url of the file to play
    /// - Throws: throw an error if the playing session can't be started.
    func startPlaying(session: AVAudioSession = AVAudioSession.sharedInstance(),
                      url: URL) throws {
        defer {
            playerDelegate.didFinishPassiveCompletion = { [weak self] _ in
                self?.publishers.currentState = .init(value: .pause)
            }
        }

        audioSession = _AudioSession()
        try audioSession?.start(session: session)

        playerSession = _PlayerSession()
        try playerSession?.start(directory: url, delegate: playerDelegate)
        publishers.currentState = .init(value: .playing)
    }

    /// stopPlaying stop the playing session.
    /// - Throws: throw an error if the playing session can't be stopped.
    @discardableResult
    func stopPlaying() async throws -> Bool {
        guard true == playerSession?.isPlaying else {
            publishers.currentState = .init(value: .pause)
            return false
        }

        return await withCheckedContinuation { continuation in
            Task { [weak self] in
                self?.playerSession?.stop()
                self?.playerSession = nil

                try self?.audioSession?.stop()
                self?.audioSession = nil

                self?.publishers.currentState = .init(value: .pause)
                continuation.resume(returning: true)
            }
        }
    }
}


