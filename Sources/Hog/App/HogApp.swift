import AppKit
import SwiftUI

@main
struct HogApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var model = HogApplicationModel()

    var body: some Scene {
        Settings {
            SettingsView(
                monitor: model.monitor,
                loginItemController: model.loginItemController
            )
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
