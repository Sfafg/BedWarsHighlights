import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    height: 65
    Layout.fillWidth: true
    color: Theme.primary4
    border.width: 1
    border.color: Theme.primary2

    RowLayout {
        id: layout

        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: -5

        Button {
            icon.name: "media-skip-backward"
            Material.background: "transparent"
            Material.foreground: Theme.primary1
            Layout.preferredHeight: 54
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: {
                Context.mediaPlayer.position -= 15 * 1000;
            }

            Shortcut {
                sequence: "H"
                onActivated: Context.mediaPlayer.position -= 5 * 1000
            }

            Shortcut {
                sequence: "Left"
                onActivated: Context.mediaPlayer.position -= 5 * 1000
            }

        }

        ToolButton {
            onClicked: Context.mediaPlayer.playing ? Context.mediaPlayer.pause() : Context.mediaPlayer.play()
            icon.name: Context.mediaPlayer.playing ? "media-playback-pause" : "media-playback-start"
            Material.background: Theme.accent2
            Material.foreground: Theme.accent
            Material.roundedScale: Material.SmallScale
            Layout.preferredHeight: 40
            Layout.preferredWidth: Layout.preferredHeight
            icon.width: Layout.preferredHeight
            icon.height: Layout.preferredHeight
            leftPadding: 10
            topPadding: 8
            bottomPadding: 8

            Shortcut {
                sequence: "Space"
                onActivated: Context.mediaPlayer.playing ? Context.mediaPlayer.pause() : Context.mediaPlayer.play()
            }

            background: Rectangle {
                radius: 8
                color: Theme.accent2
                border.width: 1
                border.color: Theme.accent1
            }

        }

        Button {
            icon.name: "media-skip-forward"
            Material.background: "transparent"
            Material.foreground: Theme.primary1
            Layout.preferredHeight: 54
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: {
                Context.mediaPlayer.position += 15 * 1000;
            }

            Shortcut {
                sequence: "L"
                onActivated: Context.mediaPlayer.position += 5 * 1000
            }

            Shortcut {
                sequence: "Right"
                onActivated: Context.mediaPlayer.position += 5 * 1000
            }

        }

        Item {
            width: 25
        }

        Text {
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize2
            color: Theme.text
            text: Utils.durationText(Context.mediaPlayer.position)
        }

        Text {
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize3
            color: Theme.textSecondary
            text: "  / " + Utils.durationText(Context.mediaPlayer.duration)
        }

        Item {
            width: 40
        }

        Slider {
            id: slider

            Material.accent: Theme.primary2
            Layout.preferredWidth: 300
            value: 1
            from: 0
            to: 5
            onMoved: {
                value = Math.max(Math.floor(value * 10) / 10, 0.1);
                Context.mediaPlayer.playbackRate = value;
            }

            Shortcut {
                sequence: "K"
                onActivated: {
                    slider.value += 0.11;
                    slider.value = Math.max(Math.floor(slider.value * 10) / 10, 0.1);
                    Context.mediaPlayer.playbackRate = slider.value;
                }
            }

            Shortcut {
                sequence: "J"
                onActivated: {
                    slider.value -= 0.11;
                    slider.value = Math.max(Math.floor(slider.value * 10) / 10, 0.1);
                    Context.mediaPlayer.playbackRate = slider.value;
                }
            }

        }

        Text {
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize3
            color: Theme.textSecondary
            text: slider.value + "x"
        }

    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Slider {
            Material.accent: Theme.primary2
            Layout.preferredWidth: 100
            value: Context.mediaPlayer.audioOutput.volume
            onMoved: {
                Context.mediaPlayer.audioOutput.volume = value;
            }
        }

        Button {
            icon.name: Context.mediaPlayer.audioOutput.muted || Context.mediaPlayer.audioOutput.volume == 0 ? "audio-volume-muted" : "audio-volume-high"
            Material.background: "transparent"
            Material.foreground: Theme.primary1
            topInset: 0
            bottomInset: 0
            leftPadding: 0
            rightPadding: 0
            verticalPadding: 0
            icon.width: 28
            icon.height: 28
            Layout.preferredHeight: 42
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: {
                Context.mediaPlayer.audioOutput.muted = !Context.mediaPlayer.audioOutput.muted;
            }

            Shortcut {
                sequence: "M"
                onActivated: Context.mediaPlayer.audioOutput.muted = !Context.mediaPlayer.audioOutput.muted
            }

        }

        Button {
            icon.name: "view-fullscreen"
            Material.background: "transparent"
            Material.foreground: Theme.primary1
            topInset: 0
            bottomInset: 0
            leftPadding: 0
            rightPadding: 0
            icon.width: 28
            icon.height: 28
            verticalPadding: 0
            Layout.preferredHeight: 42
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: {
                Context.fullScreen = !Context.fullScreen;
            }

            Shortcut {
                sequence: "F"
                onActivated: Context.fullScreen = !Context.fullScreen
            }

        }

        Item {
            width: 15
        }

    }

}
