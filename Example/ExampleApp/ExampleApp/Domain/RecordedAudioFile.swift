import Foundation

struct RecordedAudioFile: Identifiable, Equatable {
    let id: UUID = UUID()
    var sortName: String { String(id.uuidString.prefix(6)) }
    let url: URL
    var isPlaying: Bool = false

    init(url: URL) {
        self.url = url
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
