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

    //    print(AXPositionRef) this actually works and does something btw
    print(AXSizeRef.width)
    AXSizeRef.width = AXSizeRef.width / 2

    // now it is time to actually "manage the window"
    // 1. need to rewrap the CGSIZE sturct back to ax AX value
    // ^use axvalue create
    // 2. then use axuielementsetAttributevalue
    // 3.

    guard var newSize = AXValueCreate(AXValueType.cgSize, &AXSizeRef) else { return }

    // need a CFtyperef to pass in value
    AXUIElementSetAttributeValue(actualWindow, kAXSizeAttribute as CFString, newSize)

}
