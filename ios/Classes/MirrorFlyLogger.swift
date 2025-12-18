import Foundation

public class MirrorFlyLogger {
    public static let shared = MirrorFlyLogger()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    private let logQueue = DispatchQueue(label: "com.mirrorfly.logger.queue", qos: .utility)

    private init() {}

    public func log(_ message: String) {
        let timestamp = dateFormatter.string(from: Date())
        let formatted = " [iOS][MirrorflyPlugin][\(timestamp)] \(message)"
        print(formatted)
        appendToFile(formatted)
    }

    // MARK: - Private helpers

    private func appendToFile(_ text: String) {
        logQueue.async {
            guard let fileURL = self.logFileURL() else {
                print("❌ [FlyLogger] Could not resolve log file path")
                return
            }

            let line = text + "\n"
            guard let data = line.data(using: .utf8) else { return }

            do {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let handle = try FileHandle(forWritingTo: fileURL)
                    handle.seekToEndOfFile()
                    handle.write(data)
                    try handle.close()
                } else {
                    try data.write(to: fileURL)
                }
            } catch {
                print("❌ [FlyLogger] Failed to append: \(error)")
            }
        }
    }

    private func logFileURL() -> URL? {
        // Same directory as Flutter's getApplicationDocumentsDirectory()
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let date = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0

        // Flutter file naming
        let fileName = String(format: "mf_qa_logs-%d_%d_%d.txt", year, month, day)
        let fileURL = dir.appendingPathComponent(fileName)

         print("[FlyLogger] Writing to \(fileURL.path)")

        return fileURL
    }
}
