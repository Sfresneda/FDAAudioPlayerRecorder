import Foundation

/// File directory manager.
struct FileDirectoryManager {
    private static var nameGenerator: String {
        String(UUID().uuidString.prefix(4)) + Date().timeIntervalSince1970.description
    }

    static private func getDocumentsDirectory() -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return directory.first
    }
}

// MARK: - Internal
extension FileDirectoryManager {

    /// Check if the file directory is valid.
    /// - Parameter url: the file directory
    /// - Returns: true if the file directory is valid, false otherwise    
    static func isFileDirectoryValid(_ url: URL) -> Bool {
        let result = if #available(iOS 16.0, *) {
            url.path()
        } else {
            url.path
        }

        return FileManager.default.fileExists(atPath:  result)
    }

    /// Get the file directory.
    /// - Parameter name: the file name
    /// - Returns: the file directory
    /// - Throws: throw an error if the file directory can't be found.
    static func getFileUrl(name: String? = nil) throws -> URL {
        let filename = "\(name ?? nameGenerator).acc"
        let filePath = getDocumentsDirectory()?.appendingPathComponent(filename)

        guard let filePath else {
            throw FDAAudioPlayerRecorderError.documentsDirectoryNotFound
        }

        return filePath
    }

    /// Get the file directory.
    /// - Parameter name: the file name
    /// - Returns: the file directory
    /// - Throws: throw an error if the file directory can't be found.
    static func getFile(with name: String) throws -> URL {
        let directory = getDocumentsDirectory()

        let fileDirectory: URL? = if #available(iOS 16.0, *) {
            directory?.appending(path: name, directoryHint: .checkFileSystem)
        } else {
            directory?.appendingPathComponent(name)
        }

        guard let fileDirectory,
              isFileDirectoryValid(fileDirectory) else {
            throw FDAAudioPlayerRecorderError.fileNotFound
        }

        return fileDirectory
    }
}
