import Foundation

/// Simple JSON persistence to the app's Documents directory.
/// Swap this out for CoreData/SwiftData later without touching the ViewModels' public API.
struct PersistenceStore<T: Codable> {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    private var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }

    func load() -> T? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func save(_ value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
