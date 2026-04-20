import AppKit

@main

struct macwm {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        snapFrontmostWindowLeft()
    }
}

@MainActor
func snapFrontmostWindowLeft() {
    // get front most window
    // current window size
    // target window size
    let workspace = NSWorkspace.shared.frontmostApplication
    guard let pid = workspace?.processIdentifier else { return }

    let axgoon: AXUIElement = AXUIElementCreateApplication(pid)

    //
    // get the reference to the element??? let axgoonref = axgoon

    var windowsRef: CFTypeRef?
    var positionRef: CFTypeRef?
    var sizeRef: CFTypeRef?

    AXUIElementCopyAttributeValue(axgoon, kAXWindowsAttribute as CFString, &windowsRef)

    guard let window = windowsRef as? [AXUIElement] else { return }

    guard let actualWindow = window.first else { return }
    AXUIElementCopyAttributeValue(actualWindow, kAXPositionAttribute as CFString, &positionRef)
    AXUIElementCopyAttributeValue(actualWindow, kAXSizeAttribute as CFString, &sizeRef)

    let position = positionRef as! AXValue
    let size = sizeRef as! AXValue

    // position and size stored here
    var AXPositionRef = CGPoint.zero
    var AXSizeRef = CGSize.zero

    AXValueGetValue(position, AXValueGetType(position), &AXPositionRef)
    AXValueGetValue(size, AXValueGetType(size), &AXSizeRef)

}
