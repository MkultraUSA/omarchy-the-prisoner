import Quickshell
import Quickshell.Wayland
import QtQuick

// A user-level companion layer for the compact right display. Omarchy's
// background service continues to provide the primary display's wallpaper.
Item {
  id: root
  // The companion scene belongs on the right-most display. This makes the
  // theme portable: a single-monitor setup keeps the main Village image,
  // while any multi-monitor setup gets the seaside continuation.
  readonly property var companionScreen: Quickshell.screens.length > 1
    ? Quickshell.screens.reduce((rightmost, candidate) =>
        candidate.x > rightmost.x || (candidate.x === rightmost.x && candidate.y > rightmost.y)
          ? candidate : rightmost, Quickshell.screens[0])
    : null

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: modelData === root.companionScreen
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore

      WlrLayershell.namespace: "the-prisoner-seaside-background"
      // Omarchy's built-in wallpaper occupies the Background layer. Bottom
      // keeps this companion view above that wallpaper but below all windows.
      WlrLayershell.layer: WlrLayer.Bottom
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("village-seaside.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
      }
    }
  }
}
