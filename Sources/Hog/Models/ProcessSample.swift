import Foundation

struct ProcessSample: Identifiable, Equatable {
    let pid: Int
    let name: String
    let cpu: Double

    var id: Int { pid }
}

struct ProcessSnapshot: Equatable {
    var topProcesses: [ProcessSample] = []
    var sampledAt: Date?
    var errorMessage: String?

    var leader: ProcessSample? {
        topProcesses.first
    }
}
