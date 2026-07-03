import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property alias toolTip: toolTip_
    property real size: 8
    property var onClick:null

    Layout.alignment: Qt.AlignTop
    implicitWidth: 2
    implicitHeight: size * 5
    radius: height

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.size
        height: parent.size
        radius: width / 2
        color: mouse.containsMouse ? Qt.lighter(parent.color, 1.5) : parent.color
    }

    ToolTip {
        id: toolTip_

        border.color: parent.color
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: mouse.containsMouse
    }

    MouseArea {
        id: mouse

        anchors.centerIn: parent
        width: parent.width + 20
        height: parent.height
        hoverEnabled: true
        onClicked: {
            if(onClick)onClick()
        }
    }

}
