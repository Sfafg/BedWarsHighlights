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

            Rectangle {
                id: viewSpace

                clip: true
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true

                VideoOutput {
                    id: vidOutput

                    property real scaleFactor: Math.min(parent.width / sourceRect.width, parent.height / sourceRect.height)
                    property point center

                    function resetTransform() {
                        Context.videoScale = 1;
                        width = sourceRect.width * scaleFactor * Context.videoScale;
                        height = sourceRect.height * scaleFactor * Context.videoScale;
                        x = (parent.width - width) * 0.5;
                        y = (parent.height - height) * 0.5;
                        vidOutput.center.x = viewSpace.width * 0.5;
                        vidOutput.center.y = viewSpace.height * 0.5;
                    }

                    fillMode: Image.Stretch
                    width: sourceRect.width * scaleFactor
                    height: sourceRect.height * scaleFactor
                    x: (parent.width - width) * 0.5
                    y: (parent.height - height) * 0.5
                    onSourceChanged: {
                        resetTransform();
                    }
                    Component.onCompleted: {
                        vidOutput.center.x = viewSpace.width * 0.5;
                        vidOutput.center.y = viewSpace.height * 0.5;
                    }

                    Connections {
                        function onVideoScaleChanged() {
                            let s = vidOutput.width / (vidOutput.sourceRect.width * vidOutput.scaleFactor);
                            let cx = vidOutput.center.x;
                            let cy = vidOutput.center.y;
                            let ratio = Context.videoScale / s;
                            vidOutput.x = cx - (cx - vidOutput.x) * ratio;
                            vidOutput.y = cy - (cy - vidOutput.y) * ratio;
                            vidOutput.width = vidOutput.sourceRect.width * vidOutput.scaleFactor * Context.videoScale;
                            vidOutput.height = vidOutput.sourceRect.height * vidOutput.scaleFactor * Context.videoScale;
                        }

                        target: Context
                    }

                }

                MouseArea {
                    property point dragStart
                    property point initialPosition
                    property real initialScale
                    property bool rightButton

                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (Math.hypot(dragStart.x - mouse.x, dragStart.y - mouse.y) > 2)
                            return ;

                        if (mouse.button === Qt.RightButton) {
                            vidOutput.resetTransform();
                        } else {
                            vidOutput.x += viewSpace.width * 0.5 - mouse.x;
                            vidOutput.y += viewSpace.height * 0.5 - mouse.y;
                        }
                    }
                    onPressed: (mouse) => {
                        dragStart.x = mouse.x;
                        dragStart.y = mouse.y;
                        initialPosition.x = vidOutput.x;
                        initialPosition.y = vidOutput.y;
                        initialScale = Context.videoScale;
                        rightButton = mouse.button === Qt.RightButton;
                        if (rightButton) {
                            vidOutput.center.x = mouse.x;
                            vidOutput.center.y = mouse.y;
                        }
                    }
                    onPositionChanged: (mouse) => {
                        if (pressed) {
                            if (rightButton) {
                                Context.videoScale = Math.max(Math.min(initialScale - (mouse.y - dragStart.y) * 0.01, 10), 1);
                            } else {
                                vidOutput.x = initialPosition.x + (mouse.x - dragStart.x);
                                vidOutput.y = initialPosition.y + (mouse.y - dragStart.y);
                            }
                        }
                    }
                    onReleased: (mouse) => {
                        vidOutput.center.x = viewSpace.width * 0.5;
                        vidOutput.center.y = viewSpace.height * 0.5;
                    }
                }

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
