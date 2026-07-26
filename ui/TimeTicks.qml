import QtQuick

Rectangle {
    id: root

    property real timeStart
    property real timeEnd
    property real tickDistance: Utils.calculateTimeTickDistance(timeEnd - timeStart)
    property real repeaterCount: Math.ceil((timeEnd - timeStart) / tickDistance)

    color: "transparent"
    implicitWidth: 300
    implicitHeight: 20

    Repeater {
        model: root.repeaterCount + (root.repeaterCount * root.tickDistance + Utils.floorTo(root.timeStart, root.tickDistance) < Utils.duration())

        delegate: Text {
            property real time: modelData * root.tickDistance + Utils.floorTo(root.timeStart, root.tickDistance)

            x: time / Utils.duration() * root.width - implicitWidth / 2
            anchors.verticalCenter: root.verticalCenter
            width: 10
            height: 10
            text: Utils.durationText(time)
            color: Theme.textTernary
            font.family: Fnt.fontFamily
            font.pointSize: Fnt.fontSize6
        }

    }

}
