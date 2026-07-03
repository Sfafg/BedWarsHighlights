import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts

ApplicationWindow {
    id: window

    visible: true
    width: 1920
    height: 1080
    color: Theme.background

    MediaPlayer {
        id: player

        source: backend.videoPath
        videoOutput: vidOutput
        Component.onCompleted: Context.mediaPlayer = player
        autoPlay: true
        pitchCompensation: true

        audioOutput: AudioOutput {
            volume: 1
        }

    }

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true

            FileDialog {
                id: fileDialog

                title: "Select video"
                fileMode: FileDialog.OpenFile
                nameFilters: ["Videos (*.mp4 *.mkv)", "All files (*)"]
                currentFolder: "file:///home/slawek/Videos/OBS/"
                onAccepted: {
                    backend.videoPath = selectedFile;
                    Context.selectedEvent = -1;
                }
            }

            Button {
                text: "Select video"
                Material.background: "transparent"
                Material.foreground: Theme.primary1
                onClicked: fileDialog.open()

                Shortcut {
                    sequence: "O"
                    onActivated: fileDialog.open()
                }

            }

            VideoOutput {
                id: vidOutput

                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            TimeLine {
                Layout.fillWidth: true
            }

        }

        EventList {
            Layout.alignment: Qt.AlignTop
            visible: !Context.fullScreen
        }

    }

}
