import Qt5Compat.GraphicalEffects
import QtQuick

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
        onPositionChanged:
        {
            if(Context.mediaPlayer.position > (Context.mediaPlayer.duration || backend.videoDuration))
                Context.mediaPlayer.position = Context.mediaPlayer.duration || backend.videoDuration

        }
    }

}
