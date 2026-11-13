// Test helper: posts real mouse and keyboard events.
//   input trusted | click X Y | drag X1 Y1 X2 Y2 | key CODE [cmd,shift,ctrl,alt] | type TEXT
import ApplicationServices
import Foundation

// Every event goes to Herdr's process only (HERDR_PID), never to the frontmost app.
let args = CommandLine.arguments
let src = CGEventSource(stateID: .hidSystemState)
guard let pidText = ProcessInfo.processInfo.environment["HERDR_PID"], let pid = pid_t(pidText) else {
  print("HERDR_PID not set"); exit(2)
}

// Mouse events need the real pointer (Herdr ignores clicks addressed to it while inactive);
// keys always go to Herdr's process.
var global = false
func post(_ e: CGEvent?) { if global { e?.post(tap: .cghidEventTap) } else { e?.postToPid(pid) }; usleep(30_000) }

func mouse(_ type: CGEventType, _ x: Double, _ y: Double) {
  post(CGEvent(mouseEventSource: src, mouseType: type, mouseCursorPosition: CGPoint(x: x, y: y), mouseButton: .left))
}

func flags(_ s: String) -> CGEventFlags {
  var f: CGEventFlags = []
  if s.contains("cmd") { f.insert(.maskCommand) }
  if s.contains("shift") { f.insert(.maskShift) }
  if s.contains("ctrl") { f.insert(.maskControl) }
  if s.contains("alt") { f.insert(.maskAlternate) }
  return f
}

switch args[1] {
case "trusted":
  print(AXIsProcessTrusted())
case "click":
  global = true
  let x = Double(args[2])!, y = Double(args[3])!
  mouse(.mouseMoved, x, y)
  mouse(.leftMouseDown, x, y)
  mouse(.leftMouseUp, x, y)
case "drag":
  global = true
  let x1 = Double(args[2])!, y1 = Double(args[3])!, x2 = Double(args[4])!, y2 = Double(args[5])!
  mouse(.mouseMoved, x1, y1)
  mouse(.leftMouseDown, x1, y1)
  for i in 1...12 { mouse(.leftMouseDragged, x1 + (x2 - x1) * Double(i) / 12, y1 + (y2 - y1) * Double(i) / 12) }
  mouse(.leftMouseUp, x2, y2)
case "key":
  let code = CGKeyCode(Int(args[2])!)
  let f = flags(args.count > 3 ? args[3] : "")
  let down = CGEvent(keyboardEventSource: src, virtualKey: code, keyDown: true); down?.flags = f; post(down)
  let up = CGEvent(keyboardEventSource: src, virtualKey: code, keyDown: false); up?.flags = f; post(up)
case "type":
  for ch in args[2].utf16 {
    let down = CGEvent(keyboardEventSource: src, virtualKey: 0, keyDown: true)
    var c = ch; down?.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c); post(down)
    let up = CGEvent(keyboardEventSource: src, virtualKey: 0, keyDown: false)
    up?.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c); post(up)
  }
default:
  print("unknown")
}
