import AppKit
import Foundation

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let sdkRoot = "/opt/homebrew/share/android-commandlinetools"
    private let avdName = "tax35-arm64"
    private let logPath = "/tmp/tax35-emulator.log"
    private var monitorTimer: Timer?
    private let deadline = Date().addingTimeInterval(15)

    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.launchIfNeeded()
        }

        monitorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.pollLaunchStatus()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        monitorTimer?.invalidate()
    }

    private func launchIfNeeded() {
        if isEmulatorRunning() {
            return
        }

        let emulatorBinary = "\(sdkRoot)/emulator/emulator"
        FileManager.default.createFile(atPath: logPath, contents: nil)

        let command = """
        export ANDROID_SDK_ROOT='\(sdkRoot)'
        export PATH='\(sdkRoot)/platform-tools:\(sdkRoot)/emulator:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin'
        nohup '\(emulatorBinary)' '@\(avdName)' -no-snapshot-save -no-boot-anim -no-metrics >'\(logPath)' 2>&1 &
        """

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-lc", command]
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            writeError("Failed to launch emulator: \(error)")
        }
    }

    private func pollLaunchStatus() {
        if isEmulatorRunning() {
            monitorTimer?.invalidate()
            NSApp.terminate(nil)
            return
        }

        if Date() >= deadline {
            monitorTimer?.invalidate()
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = "Android 模拟器启动失败"
            alert.informativeText = "请查看 /tmp/tax35-emulator.log"
            alert.addButton(withTitle: "好")
            alert.runModal()
            NSApp.terminate(nil)
        }
    }

    private func isEmulatorRunning() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
        task.arguments = ["-f", "@\(avdName)"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()
        } catch {
            return false
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        return !output.isEmpty
    }

    private func writeError(_ message: String) {
        guard let data = (message + "\n").data(using: .utf8) else { return }
        if !FileManager.default.fileExists(atPath: logPath) {
            FileManager.default.createFile(atPath: logPath, contents: nil)
        }
        if let handle = FileHandle(forWritingAtPath: logPath) {
            try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
            try? handle.close()
        }
    }
}
