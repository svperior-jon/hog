import Foundation

@MainActor
final class HogApplicationModel: ObservableObject {
    let monitor: ProcessMonitor
    let loginItemController: LoginItemController
    private let statusItemController: StatusItemController

    init() {
        monitor = ProcessMonitor()
        loginItemController = LoginItemController()
        statusItemController = StatusItemController(monitor: monitor)
        monitor.start()
    }
}
