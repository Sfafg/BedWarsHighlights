import QtQuick

Rectangle {
    id: root

    property real timeStart
    property real timeEnd
    property real keyFrameTimeDistance: Utils.calculateTimeTickDistance(Math.pow(timeEnd - timeStart, 0.999) * 0.8)
    property real visibleWidth: (timeEnd - timeStart) / Utils.duration() * parent.width
    property int indexOffset: -(Utils.floorTo(-keyFrameTimeDistance + Utils.floorTo(timeStart, keyFrameTimeDistance) + keyFrameTimeDistance * 0.5, 1000) > 0)
    property int candidateCount: Math.floor((timeEnd - timeStart) / keyFrameTimeDistance) + (indexOffset != 0)
    property int repeaterCount: candidateCount + (Utils.floorTo(candidateCount * keyFrameTimeDistance + Utils.floorTo(timeStart, keyFrameTimeDistance) + keyFrameTimeDistance * 0.5, 1000) < Utils.duration()) + (Utils.floorTo((candidateCount + 1) * keyFrameTimeDistance + Utils.floorTo(timeStart, keyFrameTimeDistance) + keyFrameTimeDistance * 0.5, 1000) < Utils.duration())

    color: "transparent"
    implicitWidth: 300
    implicitHeight: 120

    Repeater {
        model: root.repeaterCount
        z: 0

        delegate: Image {
            property real timestamp: Utils.floorTo((root.repeaterCount - modelData - 1 + root.indexOffset) * root.keyFrameTimeDistance + Utils.floorTo(root.timeStart, root.keyFrameTimeDistance) + root.keyFrameTimeDistance * 0.5, 1000)
            property real oldTimestamp: -1

            x: timestamp / Utils.duration() * root.width - width * 0.5
            anchors.verticalCenter: root.verticalCenter
            width: root.visibleWidth / ((timeEnd - timeStart) / keyFrameTimeDistance)
            height: 90
            asynchronous: true
            onTimestampChanged: {
                if (oldTimestamp != -1)
                    backend.removeKeyFrameGenerationJob(oldTimestamp);

                oldTimestamp = timestamp;
                let path = cwd + "/thumbnails/" + backend.videoPathFileName() + "/frame_" + timestamp / 1000 + ".jpg";
                if (backend.isValidPath(path)) {
                    source = "file://" + path;
                } else {
                    backend.addKeyFrameGenerationJob(timestamp);
                    source = "";
                }
            }
            Component.onDestruction: backend.removeKeyFrameGenerationJob(timestamp)

            Connections {
                function onKeyFrameChanged(tim) {
                    if (tim == timestamp)
                        source = "file://" + cwd + "/thumbnails/" + backend.videoPathFileName() + "/frame_" + timestamp / 1000 + ".jpg";

                }

                function onVideoPathChanged() {
                    oldTimestamp = -1;
                    backend.addKeyFrameGenerationJob(timestamp);
                }

                target: backend
            }

        }

    }

}
