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
    @Published var cpuThreshold: Double = 50 {
        didSet {
            guard cpuThreshold != oldValue else { return }
            sustainedFilter.reset()
            snapshot = ProcessSnapshot(topProcesses: [], sampledAt: Date(), errorMessage: nil)
        }
    }

    private let sampler = ProcessSampler()
    private var sustainedFilter = SustainedProcessFilter()
    private var task: Task<Void, Never>?

    deinit {
        task?.cancel()
    }

    func start() {
        guard task == nil else { return }
        restart()
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
            let sampler = sampler
            let samples = try await Task.detached(priority: .utility) {
                try sampler.sample(limit: 30)
            }.value
            let now = Date()
            let processes = sustainedFilter.update(
                samples: samples,
                at: now,
                threshold: cpuThreshold,
                minimumDuration: 30,
                limit: 3
            )
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
