import Foundation

struct ProcessSampler {
    var processNameExclusions: Set<String> = ["Hog", "ps"]

    func sample(limit: Int = 3) async throws -> [ProcessSample] {
        let output = try await runPS()
        return parse(output: output)
            .filter { !processNameExclusions.contains($0.name) }
            .sorted { lhs, rhs in
                if lhs.cpu == rhs.cpu {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.cpu > rhs.cpu
            }
            .prefix(limit)
            .map { $0 }
    }

    func parse(output: String) -> [ProcessSample] {
        output
            .split(separator: "\n")
            .compactMap { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return nil }

                let fields = trimmed.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
                guard fields.count == 3,
                      let pid = Int(fields[0]),
                      let cpu = Double(fields[1]) else {
                    return nil
                }

                let executable = String(fields[2])
                let name = URL(fileURLWithPath: executable).lastPathComponent
                guard !name.isEmpty else { return nil }

                return ProcessSample(pid: pid, name: name, cpu: cpu)
            }
    }

    private func runPS() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            let pipe = Pipe()

            process.executableURL = URL(fileURLWithPath: "/bin/ps")
            process.arguments = ["-axo", "pid=,pcpu=,comm="]
            process.standardOutput = pipe
            process.standardError = Pipe()

            process.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""

                if process.terminationStatus == 0 {
                    continuation.resume(returning: output)
                } else {
                    continuation.resume(throwing: SamplerError.psFailed(process.terminationStatus))
                }
            }

            do {
                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum SamplerError: LocalizedError {
    case psFailed(Int32)

    var errorDescription: String? {
        switch self {
        case .psFailed(let status):
            return "Process snapshot failed with status \(status)."
        }
    }
}
