import Combine
import Foundation

// MARK: - AudioPlayerRecorderPublishers
/// Publishers for the audio player and recorder.
public final class AudioPlayerRecorderPublishers {
    @Published public internal(set) var peakValue: PeakValueModel = .init(value: .zero)
    @Published public internal(set) var isSpeakerActive: SpeakerStatusModel = .init(value: false)
    @Published public internal(set) var currentState: AudioCurrentStateModel = .init(value: .pause)

    @Published public internal(set) var recorderErrorPublisher: RecorderErrorModel?
    @Published public internal(set) var playerErrorPublisher: PlayerErrorModel?
}

// MARK: - Helper
public extension AudioPlayerRecorderPublishers {

    /// Allow to observe all the properties of the publishers, just passing 
    /// a block that will be called when a property change.
    /// - Parameters:
    ///  - returningBlock: the block that will be called when a property change
    /// - cancellables: the cancellables set
    func observeAllProperties(returningBlock: @escaping ((Any?) -> Void),
                              store cancellables: inout Set<AnyCancellable>) {
        $peakValue
            .receive(on: DispatchQueue.main)
            .sink { value in
                returningBlock(value)
            }.store(in: &cancellables)

        $isSpeakerActive
            .receive(on: DispatchQueue.main)
            .sink { value in
                returningBlock(value)
            }.store(in: &cancellables)

        $currentState
            .receive(on: DispatchQueue.main)
            .sink { value in
                returningBlock(value)
            }.store(in: &cancellables)

        $recorderErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { value in
                returningBlock(value)
            }.store(in: &cancellables)

        $playerErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { value in
                returningBlock(value)
            }.store(in: &cancellables)
    }
}
