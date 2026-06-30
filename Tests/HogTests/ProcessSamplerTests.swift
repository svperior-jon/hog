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
}
