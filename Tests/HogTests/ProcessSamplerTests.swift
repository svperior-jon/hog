import Foundation
import Testing
@testable import Hog

struct ProcessSamplerTests {
    @Test
    func parserReadsPSRowsAndUsesExecutableNames() {
        let output = """
          100   4.2 /Applications/Safari.app/Contents/MacOS/Safari
          101  15.7 /usr/libexec/WindowServer
          bad row
          102   0.0 /bin/ps
        """

        let samples = ProcessSampler().parse(output: output)

        #expect(samples == [
            ProcessSample(pid: 100, name: "Safari", cpu: 4.2),
            ProcessSample(pid: 101, name: "WindowServer", cpu: 15.7),
            ProcessSample(pid: 102, name: "ps", cpu: 0.0)
        ])
    }

    @Test
    func sampleReturnsCurrentProcesses() throws {
        let samples = try ProcessSampler().sample(limit: 3)

        #expect(!samples.isEmpty)
    }

    @Test
    func sustainedFilterRequiresContinuousThresholdDuration() {
        var filter = SustainedProcessFilter()
        let start = Date(timeIntervalSince1970: 0)
        let sample = ProcessSample(pid: 10, name: "Worker", cpu: 51)

        let first = filter.update(
            samples: [sample],
            at: start,
            threshold: 50,
            minimumDuration: 30,
            limit: 3
        )
        let early = filter.update(
            samples: [sample],
            at: start.addingTimeInterval(29),
            threshold: 50,
            minimumDuration: 30,
            limit: 3
        )
        let qualified = filter.update(
            samples: [sample],
            at: start.addingTimeInterval(30),
            threshold: 50,
            minimumDuration: 30,
            limit: 3
        )

        #expect(first.isEmpty)
        #expect(early.isEmpty)
        #expect(qualified == [sample])
    }

    @Test
    func sustainedFilterResetsWhenProcessDropsBelowThreshold() {
        var filter = SustainedProcessFilter()
        let start = Date(timeIntervalSince1970: 0)
        let high = ProcessSample(pid: 10, name: "Worker", cpu: 51)
        let low = ProcessSample(pid: 10, name: "Worker", cpu: 49)

        _ = filter.update(samples: [high], at: start, threshold: 50, minimumDuration: 30, limit: 3)
        _ = filter.update(samples: [low], at: start.addingTimeInterval(10), threshold: 50, minimumDuration: 30, limit: 3)
        let result = filter.update(samples: [high], at: start.addingTimeInterval(35), threshold: 50, minimumDuration: 30, limit: 3)

        #expect(result.isEmpty)
    }
}
