import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property color theme: Evnt.kill.color
    property alias iconSource: icon.source
    property alias descriptionText: description.text
    property alias timeText: time.text
    property bool selected: true

    height: 80
    width: parent.width
    color: selected ? Qt.lighter(theme, 0.199) : Theme.background
    radius: 3
    border.width: 1
    border.color: Theme.primary3

    RowLayout {
        id: layout

        Item {
        }

        Rectangle {
            height: root.height
            width: 3
            color: root.selected ? root.theme : Theme.background
        }

        Image {
            id: icon

            source: Evnt.kill.icon
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignTop
            Layout.margins: 10
            visible: false
        }

        ColorOverlay {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignTop
            Layout.margins: 10
            source: icon
            color: root.theme
        }

        Text {
            id: description

            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
            padding: 10
            topPadding: 22
            text: "Ersit destroyed a bed"
            color: Theme.text
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize2
            Layout.alignment: Qt.AlignTop
        }

    }

    Text {
        id: time

        padding: 8
        text: "4:00"
        color: Theme.textSecondary
        font.family: Fnt.fontFamily
        font.pixelSize: Fnt.fontSize4
        anchors.top: parent.top
        anchors.right: parent.right
    }

}
