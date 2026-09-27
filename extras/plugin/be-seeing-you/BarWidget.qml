import QtQuick
import qs.Commons
import qs.Ui

// The Village salute from The Prisoner. Left-click locks the screen, the way
// the Village says goodbye. The hand is a small vector drawn in the bar's
// text colour, so it stays crisp and follows any theme.
BarWidget {
  id: root
  moduleName: "uk.co.mkultrausa.be-seeing-you"

  readonly property color glyphColor: root.bar ? root.bar.barForeground : Color.foreground
  readonly property string glyphSvg: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"> <g transform="translate(1.6 1) scale(0.9)"> <g fill="COLOR"> <!-- Middle, ring and little fingers, fanned upward --> <rect x="2.6" y="4" width="3" height="11" rx="1.5" transform="rotate(-20 4.1 15)"/> <rect x="6.6" y="0.8" width="3.1" height="13" rx="1.55" transform="rotate(-7 8.15 14)"/> <rect x="10.6" y="1.4" width="3" height="12" rx="1.5" transform="rotate(6 12.1 13.4)"/> <!-- Palm --> <path d="M4.2 12.6 H14.2 L14.6 17 Q14.4 22.6 9.4 22.6 Q4.6 22.4 4.2 17.4 Z"/> </g> <!-- Thumb and forefinger making the "O", up at fingertip height --> <circle cx="17.4" cy="9.6" r="3.9" fill="none" stroke="COLOR" stroke-width="2.3"/> <path d="M14.2 15.2 Q15.6 14.8 15.8 13" fill="none" stroke="COLOR" stroke-width="2.3" stroke-linecap="round"/> </g> </svg>'

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    tooltipText: "Be seeing you. Click to lock"
    iconComponent: Component {
      Item {
        Image {
          anchors.centerIn: parent
          width: Style.space(17)
          height: width
          sourceSize.width: width * 2
          sourceSize.height: height * 2
          smooth: true
          source: "data:image/svg+xml;utf8," + encodeURIComponent(
            root.glyphSvg.replace(/COLOR/g, root.glyphColor.toString()))
        }
      }
    }
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) root.bar.run("omarchy-system-lock")
    }
  }
}
