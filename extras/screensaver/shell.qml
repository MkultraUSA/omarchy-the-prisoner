//@ pragma AppId org.omarchy.screensaver
//@ pragma ShellId the-prisoner-rover
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root
    property real elapsed: 0
    readonly property real started: Date.now()
    readonly property real duration: Number(Quickshell.env("PRISONER_PREVIEW_SECONDS") || "0")
    readonly property bool preview: Quickshell.env("PRISONER_WINDOWED") === "1"
    readonly property real leftEdge: Math.min.apply(null, Quickshell.screens.map(s => s.x))
    readonly property real topEdge: Math.min.apply(null, Quickshell.screens.map(s => s.y))
    readonly property real desktopWidth: Math.max.apply(null, Quickshell.screens.map(s => s.x + s.width)) - leftEdge
    readonly property real desktopHeight: Math.max.apply(null, Quickshell.screens.map(s => s.y + s.height)) - topEdge
    readonly property var companionScreen: Quickshell.screens.length > 1
        ? Quickshell.screens.reduce((rightmost, candidate) =>
            candidate.x > rightmost.x || (candidate.x === rightmost.x && candidate.y > rightmost.y)
              ? candidate : rightmost, Quickshell.screens[0])
        : null
    readonly property real pass: Math.floor(elapsed / 34)
    readonly property real progress: (elapsed % 34) / 34
    readonly property real travel: progress + 0.024 * Math.sin(progress * Math.PI * 4)
    readonly property bool reverse: pass % 2 === 1
    readonly property real diameter: desktopHeight * (pass % 3 === 2 ? 0.67 : 0.29)
    readonly property real roverX: -diameter + (desktopWidth + diameter * 2) * (reverse ? 1 - travel : travel)
    readonly property real roverY: desktopHeight * 0.69 - diameter * 0.5 + Math.sin(elapsed * 1.8) * diameter * 0.035

    Timer {
        interval: 33; running: true; repeat: true
        onTriggered: {
            root.elapsed = (Date.now() - root.started) / 1000
            if (root.duration > 0 && root.elapsed >= root.duration) Qt.quit()
        }
    }

    IpcHandler {
        target: "rover"
        function stop(): void { Qt.quit() }
    }

    Variants {
        model: (root.preview ? [Quickshell.screens[0]] : Quickshell.screens).map(s => s.name)
        FloatingWindow {
            id: window
            required property var modelData
            readonly property var targetScreen: Quickshell.screens.find(s => s.name === modelData)
            screen: targetScreen
            title: "The Prisoner — Rover — " + modelData
            visible: true
            fullscreen: false
            implicitWidth: 960
            implicitHeight: 540
            color: "#eee6ce"
            onClosed: Qt.quit()

            // Hyprland can ignore Qt's initial output request. Move each named
            // window explicitly before setting fullscreen on that output.
            Timer {
                id: placement
                interval: 350; running: !root.preview; repeat: true
                property int attempts: 0
                onTriggered: {
                    if (moveToOutput.running) return
                    if (++attempts > 8) { console.error("Cannot place Rover on " + window.modelData); Qt.quit(); return }
                    moveToOutput.running = true
                }
            }
            Process {
                id: moveToOutput
                command: ["hyprctl", "dispatch", "hl.dsp.window.move({monitor=" + JSON.stringify(window.modelData) + ",window=" + JSON.stringify("title:^" + window.title + "$") + ",follow=false})"]
                onExited: exitCode => {
                    if (exitCode === 0) { placement.stop(); fullscreenOutput.running = true }
                }
            }
            Process {
                id: fullscreenOutput
                command: ["hyprctl", "dispatch", "hl.dsp.window.fullscreen({mode=\"fullscreen\",action=\"set\",window=" + JSON.stringify("title:^" + window.title + "$") + "})"]
            }

            Item {
                id: scene
                anchors.fill: parent
                clip: true
                focus: true
                Keys.onPressed: event => { event.accepted = true; Qt.quit() }

                Timer {
                    interval: Number(Quickshell.env("PRISONER_CAPTURE_SECONDS") || "14") * 1000
                    running: Quickshell.env("PRISONER_CAPTURE_DIR") !== ""
                    onTriggered: scene.grabToImage(result => result.saveToFile(Quickshell.env("PRISONER_CAPTURE_DIR") + "/rover-" + window.modelData + ".png"))
                }

                Image {
                    anchors.fill: parent
                    // The right-most display gets a companion view across the estuary;
                    // a single-monitor setup stays in the original Village courtyard.
                    source: Qt.resolvedUrl(window.targetScreen === root.companionScreen ? "village-seaside.png" : "village-empty.png")
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: false
                }

                // Every screen sees the same virtual-desktop path. On unequal
                // monitors Rover crosses the physical boundary without restarting.
                Item {
                    id: rover
                    readonly property real factor: root.preview ? scene.width / root.desktopWidth : 1
                    width: root.diameter * factor
                    height: width
                    x: (root.roverX - (root.preview ? 0 : window.targetScreen.x - root.leftEdge)) * factor
                    y: root.preview ? scene.height * 0.65 - height / 2 : root.roverY - (window.targetScreen.y - root.topEdge)

                    Canvas {
                        x: -parent.width * 0.12
                        y: parent.height * 0.86
                        width: parent.width * 1.4
                        height: parent.height * 0.23
                        onPaint: {
                            let c = getContext("2d")
                            c.reset()
                            c.scale(width / 400, height / 100)
                            let g = c.createRadialGradient(200, 50, 0, 200, 50, 185)
                            g.addColorStop(0, "#660d1c12")
                            g.addColorStop(1, "#000d1c12")
                            c.fillStyle = g
                            c.fillRect(0, 0, 400, 100)
                        }
                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()
                    }

                    Canvas {
                        id: sphere
                        anchors.fill: parent
                        antialiasing: true
                        transform: Scale {
                            origin.x: sphere.width / 2
                            origin.y: sphere.height
                            xScale: 1 + 0.027 * Math.sin(root.elapsed * 2.6)
                            yScale: 1 - 0.023 * Math.sin(root.elapsed * 2.6)
                        }
                        onPaint: {
                            let c = getContext("2d")
                            c.reset()
                            c.scale(width / 512, height / 512)
                            let g = c.createRadialGradient(161, 131, 12, 258, 254, 248)
                            g.addColorStop(0, "#ffffff")
                            g.addColorStop(0.43, "#fffdf2")
                            g.addColorStop(0.75, "#eeeada")
                            g.addColorStop(0.93, "#cecdbf")
                            g.addColorStop(1, "#a7ada0")
                            c.fillStyle = g
                            c.beginPath()
                            c.arc(256, 256, 244, 0, Math.PI * 2)
                            c.fill()
                            c.strokeStyle = "#88ffffff"
                            c.lineWidth = 1.5
                            c.stroke()
                        }
                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()
                    }
                }

                // A quiet title moves between corners each pass.
                Rectangle {
                    x: root.pass % 2 ? 32 : scene.width - width - 32
                    y: 32
                    width: label.width + 38
                    height: 56
                    radius: 3
                    color: "#d9f4ecd8"
                    Row {
                        id: label
                        anchors.centerIn: parent
                        spacing: 14
                        Text { text: "6"; font.family: "serif"; font.pixelSize: 34; color: "#b82e36" }
                        Text { text: "BE SEEING YOU"; anchors.verticalCenter: parent.verticalCenter; font.pixelSize: 13; font.letterSpacing: 3; color: "#282e28" }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.BlankCursor
                    property real lastX: -1
                    property real lastY: -1
                    onPressed: Qt.quit()
                    onWheel: Qt.quit()
                    onPositionChanged: mouse => {
                        if (root.elapsed > 2 && lastX >= 0 && Math.abs(mouse.x - lastX) + Math.abs(mouse.y - lastY) > 3) Qt.quit()
                        lastX = mouse.x; lastY = mouse.y
                    }
                }
            }
        }
    }
}
