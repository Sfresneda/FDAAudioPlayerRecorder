import Foundation

/// FDA Audio Player Recorder error.
public enum FDAAudioPlayerRecorderError: Error, CustomStringConvertible {

    /// User documents directory can't be reached.
    case documentsDirectoryNotFound

    /// Output directory not found.
    case outputDirectoryNotFound

    /// Request file not found at documents directory.
    case fileNotFound

    /// Internal recorder error.
    case internalRecorderError(Error)

    /// Internal player error.
    case internalPlayerError(Error)

    public var description: String {
        switch self {
        case .documentsDirectoryNotFound:
            return "User documents directory can't be reached"
        case .outputDirectoryNotFound:
            return "Output directory not found"
        case .fileNotFound:
            return "Request file not found at documents directory"
        case .internalRecorderError(let error),
                .internalPlayerError(let error):
            return error.localizedDescription
        }
    }
}
