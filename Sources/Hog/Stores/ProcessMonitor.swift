import Foundation

@MainActor
final class ProcessMonitor: ObservableObject {
    @Published private(set) var snapshot = ProcessSnapshot()
    @Published var refreshInterval: TimeInterval = 5 {
        didSet {
            guard refreshInterval != oldValue else { return }
            restart()
        }
    }

    private let sampler = ProcessSampler()
    private var task: Task<Void, Never>?

    init() {
        restart()
    }

    deinit {
        task?.cancel()
    }

    func refreshNow() {
        task?.cancel()
        restart(immediateOnly: false)
    }

    private func restart(immediateOnly: Bool = false) {
        task?.cancel()
        task = Task { [weak self] in
            guard let self else { return }

            while !Task.isCancelled {
                await self.refresh()

                if immediateOnly {
                    break
                }

                let interval = UInt64(max(self.refreshInterval, 2) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: interval)
            }
        }
    }

    private func refresh() async {
        do {
            let processes = try await sampler.sample(limit: 3)
            snapshot = ProcessSnapshot(topProcesses: processes, sampledAt: Date(), errorMessage: nil)
        } catch {
            snapshot = ProcessSnapshot(
                topProcesses: snapshot.topProcesses,
                sampledAt: Date(),
                errorMessage: error.localizedDescription
            )
        }
    }
}
