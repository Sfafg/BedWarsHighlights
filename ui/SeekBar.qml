import Qt5Compat.GraphicalEffects
import QtQuick

Rectangle {
    id: track

    property real timeScale: 1
    property real timeOffset: 0

    implicitHeight: 3
    implicitWidth: parent.width * timeScale
    x: -timeOffset * parent.width
    radius: 5
    color: Theme.primary4
    anchors.bottom: parent.bottom

    Connections {
        function onVideoPathChanged() {
            timeScale = 1;
            timeOffset = 0;
        }

        target: backend
    }

    EventTicks {
        width: parent.width
        anchors.bottom: timeTicks.top
        anchors.bottomMargin: 15
    }

    TimeTicks {
        id: timeTicks

        timeStart: (track.timeOffset / track.timeScale) * Utils.duration()
        timeEnd: timeStart + Utils.duration() / track.timeScale
        width: parent.width
        anchors.bottom: parent.top
    }

    KeyFrames {
        id: keyFrames

        timeStart: (track.timeOffset / track.timeScale) * Utils.duration()
        timeEnd: timeStart + Utils.duration() / track.timeScale
        width: parent.width
        anchors.top: parent.top
    }

    SeekPoint {
        z: 20
    }

    MouseArea {
        property bool rightButton
        property point mousePos
        property real velocity
        property real mouseDragStart

        width: parent.width
        anchors.bottom: keyFrames.bottom
        anchors.top: timeTicks.top
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            rightButton = mouse.button == Qt.RightButton;
            if (rightButton) {
                let mouseDelta = mouse.x + track.x - mouseDragStart;
                if (Math.abs(mouseDelta) < 2)
                    velocity = 0;

            }
        }
        onPositionChanged: (mouse) => {
            if (rightButton) {
                let mouseDelta = mouse.x - mousePos.x;
                velocity -= mouseDelta * 0.04;
                animation.running = true;
            } else {
                let p = Math.max(0, Math.min(1, mouse.x / track.width));
                Context.mediaPlayer.position = (Context.mediaPlayer.duration || backend.videoDuration) * p;
            }
            mousePos.x = mouse.x;
            mousePos.y = mouse.y;
        }
        onPressed: (mouse) => {
            rightButton = mouse.button == Qt.RightButton;
            mouseDragStart = mouse.x + track.x;
            if (rightButton) {
            } else {
                let p = Math.max(0, Math.min(1, mouse.x / track.width));
                Context.mediaPlayer.position = (Context.mediaPlayer.duration || backend.videoDuration) * p;
            }
            mousePos.x = mouse.x;
            mousePos.y = mouse.y;
        }
        onWheel: (wheel) => {
            let s = track.timeScale;
            let c = wheel.x / track.width;
            let ct = (c + track.timeOffset) / s;
            track.timeScale = Math.min(Math.max(track.timeScale + track.timeScale * wheel.angleDelta.y * 0.001, 1), Utils.duration() / (30 * 1000));
            track.timeOffset = ct * track.timeScale - c;
            track.timeOffset = Math.max(Math.min(track.timeOffset, track.timeScale - 1), 0);
            wheel.accepted = true;
        }

        Timer {
            id: animation

            interval: 8
            repeat: true
            onTriggered: {
                parent.velocity *= 0.99;
                let newOffset = track.timeOffset + parent.velocity / track.parent.width;
                if (newOffset < 0 || newOffset > track.timeScale - 1) {
                    parent.velocity = 0;
                    running = false;
                    track.timeOffset = Math.max(Math.min(newOffset, track.timeScale - 1), 0);
                } else {
                    track.timeOffset = newOffset;
                }
                if (Math.abs(parent.velocity) < 0.01) {
                    parent.velocity = 0;
                    running = false;
                }
            }
        }

    }

    Connections {
        function onPositionChanged() {
            if (Context.mediaPlayer.position > (Context.mediaPlayer.duration || backend.videoDuration))
                Context.mediaPlayer.position = Context.mediaPlayer.duration || backend.videoDuration;

        }

        target: Context.mediaPlayer
    }

}
