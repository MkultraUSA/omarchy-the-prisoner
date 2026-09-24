import Quickshell
import Quickshell.Wayland
import QtQuick

// A user-level companion layer for the compact right display. Omarchy's
// background service continues to provide the primary display's wallpaper.
Item {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: modelData.name === "DP-3"
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore

      WlrLayershell.namespace: "the-prisoner-seaside-background"
      WlrLayershell.layer: WlrLayer.Background
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
