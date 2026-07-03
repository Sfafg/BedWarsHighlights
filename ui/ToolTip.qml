import QtQuick
import QtQuick.Layouts

Rectangle {
    property alias descriptionText: description.text
    property alias eventText: eventType.text
    property alias timeText: time.text

    implicitWidth: 190
    implicitHeight: 130
    radius: 5
    color: Theme.primary4
    border.width: 1
    border.color: Theme.tickRed

    Text {
        id: eventType

        width: parent.width
        font.family: Fnt.fontFamily
        font.pixelSize: Fnt.fontSize3
        text: "Kill"
        color: parent.border.color
        padding: 10
    }

    Text {
        id: time

        font.family: Fnt.fontFamily
        font.pixelSize: Fnt.fontSize4
        text: "2:10"
        color: Theme.textSecondary
        anchors.right: parent.right
        padding: 10
    }

    Text {
        id: description

        width: parent.width
        font.family: Fnt.fontFamily
        font.pixelSize: Fnt.fontSize1
        text: "Ersit killed Sfafg"
        color: Theme.text
        anchors.top: eventType.bottom
        leftPadding: 10
        wrapMode: Text.WordWrap
    }

}
