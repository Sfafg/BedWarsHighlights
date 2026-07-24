import Qt5Compat.GraphicalEffects
import QtQuick
import QtMultimedia

Rectangle {
    id: track

    implicitHeight: 3
    implicitWidth: 500
    radius: 5
    color: Theme.primary4

    Rectangle {
        height: parent.height
        width: parent.width * Math.min(Context.mediaPlayer?.position / (Context.mediaPlayer?.duration || backend.videoDuration),1)
        radius: 5
        color: Theme.accent

        Rectangle {
            implicitHeight: 80
            implicitWidth: 2
            radius: 2
            color: Theme.accent
            anchors.horizontalCenter: point.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        Glow {
            anchors.fill: point
            source: point
            radius: 16
            samples: 32
            color: Theme.accent
            spread: 0.2
        }

        Rectangle {
            anchors.horizontalCenter: point.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height + 10
            width: parent.height + 10
            radius: parent.height
            color: Theme.primary4
        }

        Rectangle {
            id: point

            x: parent.width - width / 2
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height + 6
            width: parent.height + 6
            radius: parent.height
            color: Theme.accent

    Rectangle {
        width: 270 / 2
        height: 130 / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 20
        z:-100

        VideoOutput {
            id: output

            anchors.fill: parent
            fillMode: VideoOutput.Stretch

            MediaPlayer {
                id: player

                property real pos: -1

                autoPlay: true
                videoOutput: output
                source: backend.videoPath
                onMediaStatusChanged: {
                    if (mediaStatus === MediaPlayer.LoadedMedia)
                        pause();

                }

                audioOutput: AudioOutput {
                    volume: 0
                }

            }

        }

    }
        }

    }
    MouseArea {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height + 30
        cursorShape: Qt.PointingHandCursor
        onPositionChanged: (mouse) => {
            let p = Math.max(0, Math.min(1, mouse.x / track.width));
            Context.mediaPlayer.position =  (Context.mediaPlayer.duration || backend.videoDuration)* p;
        }
        onPressed: (mouse) => {
            let p = Math.max(0, Math.min(1, mouse.x / track.width));
            Context.mediaPlayer.position = (Context.mediaPlayer.duration || backend.videoDuration) * p;
        }
    }

    Connections{
        target: Context.mediaPlayer
        function onPositionChanged()
        {
            if(Context.mediaPlayer.position > (Context.mediaPlayer.duration || backend.videoDuration))
                Context.mediaPlayer.position = Context.mediaPlayer.duration || backend.videoDuration

        }
    }

}
