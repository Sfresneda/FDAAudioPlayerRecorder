import Combine
import FDAAudioPlayerRecorder
import Foundation

final class ContentViewModel: ObservableObject {
    private var audioManager = FDAAudioPlayerRecorder()

    @Published
    var currentState: FDASessionState = .pause {
        willSet {
            switch newValue {
            case .pause:
                primaryButtonTitle = "Record"
            case .playing:
                primaryButtonTitle = "Switch speaker"
            case .recording:
                primaryButtonTitle = "Stop"
            }
        }
    }
    @Published var permissionState: FDAPermissionStatus = .unknown
    @Published var peakValue: Float = .zero
    @Published var files: [RecordedAudioFile] = []
    @Published var arePermissionGranted: Bool = false

    @ObservationIgnored
    var primaryButtonTitle: String = ""
    @ObservationIgnored
    var isFilesStorageEmpty: Bool {
        files.isEmpty
    }

    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    init() {
        permissionState = FDAAudioPlayerRecorder.microphonePermission.status
        arePermissionGranted = FDAAudioPlayerRecorder.microphonePermission.arePermissionGranteed
        bind()
    }

    deinit {
        unbind()
    }
}

extension ContentViewModel {
    func askForPermission() async {
        Task { @MainActor in
            let result = await FDAAudioPlayerRecorder.microphonePermission.askForPermission()
            permissionState = FDAAudioPlayerRecorder.microphonePermission.status
            arePermissionGranted.toggle()
            arePermissionGranted = result
        }
    }

    func doPrimaryAction() {
        switch currentState {
        case .pause:
            record()
        case .playing:
            switchSpeaker()

        case .recording:
            stop()
        }
    }

    // MARK: Player
    func play(file: RecordedAudioFile) {
        try? audioManager.startPlaying(url: file.url)
    }

    func pause() {
        Task {
            try? await audioManager.stopPlaying()
        }
    }

    func switchSpeaker() {
        let currentValue = audioManager.publishers.isSpeakerActive
        audioManager.setAudioSpeaker(!currentValue.value)
    }

    // MARK: Recorder
    func record() {
        try? audioManager.startRecording()
    }

    func stop() {
        Task {
            guard true == (try? await audioManager.stopRecording()),
                  let newFile = audioManager.currentFileDirectory else {
                return
            }

            await MainActor.run {
                files.append(.init(url: newFile))
            }
        }
    }
}

// MARK: - Helpers
private extension ContentViewModel {
    func bind() {
        audioManager
            .publishers
            .observeAllProperties(returningBlock: { [weak self] value in
                switch value {
                case let x as AudioCurrentStateModel:
                    self?.currentState = x.value

                case let x as PeakValueModel:
                    self?.peakValue = x.value
                
                default:
                    return
                }
            }, store: &cancellables)
    }

    func unbind() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
