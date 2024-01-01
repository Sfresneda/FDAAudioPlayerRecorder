import Foundation

/// Peak value publisher model.
public struct PeakValueModel { public let value: Float }

/// Speaker status publisher model.
public struct SpeakerStatusModel { public let value: Bool }

/// Audio current state publisher model.
public struct AudioCurrentStateModel { public let value: FDASessionState }

/// Recorder error publisher model.
public struct RecorderErrorModel { public let value: FDAAudioPlayerRecorderError }

/// Player error publisher model.
public struct PlayerErrorModel { public let value: FDAAudioPlayerRecorderError }
