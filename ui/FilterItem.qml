import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts

Rectangle {
    property alias iconColor: overlay.color
    property alias iconSource: icon.source
    property alias filterText: text.text
    property var onClick: null
    property bool isActive: true

    height: layout.implicitHeight
    width: layout.implicitWidth
    color: isActive ? Qt.tint(Theme.primary4, Qt.darker(iconColor, 4)) : Theme.primary4
    radius: 3
    border.width: 1
    border.color: Theme.primary2

    RowLayout {
        id: layout

        Item {
        }

        Image {
            id: icon

            visible: false
        }

        ColorOverlay {
            id: overlay

            Layout.preferredWidth: 15
            Layout.preferredHeight: 15
            Layout.alignment: Qt.AlignTop
            Layout.margins: 5
            source: icon
        }

        Text {
            id: text

            text: "BedDestroyed"
            color: Theme.textSecondary
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            padding: 5
            leftPadding: 15
            rightPadding: 0
        }

    }

    MouseArea {
        id: area

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
            if (onClick)
                onClick(mouse.button == Qt.LeftButton);

        }
    }

}
