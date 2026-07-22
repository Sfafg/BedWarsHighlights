import QtQuick
import QtQuick.Layouts

Rectangle {
    width: 360
    Layout.fillHeight: true
    color: Theme.background
    border.width: 1
    border.color: Theme.primary3

    ListView {
        id: listView

        anchors.fill: parent
        model: backend.events
        spacing: 0
        currentIndex: Context.selectedEvent
        highlightMoveVelocity: 4000

        Shortcut {
            sequence: "Ctrl+J"
            onActivated: {
                for (let i = Context.selectedEvent + 1; i < listView.count; ++i) {
                    const e = listView.itemAtIndex(i);
                    if (Context.selectedEvent == -1 || e.timeStmp != listView.itemAtIndex(Context.selectedEvent).timeStmp) {
                        Context.selectedEvent = i;
                        Context.mediaPlayer.position = listView.currentItem.timeStmp;
                        break;
                    }
                }
            }
        }

        Shortcut {
            sequence: "Ctrl+K"
            onActivated: {
                for (let i = Context.selectedEvent - 1; i >= 0; --i) {
                    const e = listView.itemAtIndex(i);
                    if (Context.selectedEvent == -1 || e.timeStmp != listView.itemAtIndex(Context.selectedEvent).timeStmp) {
                        Context.selectedEvent = i;
                        Context.mediaPlayer.position = listView.currentItem.timeStmp;
                        break;
                    }
                }
            }
        }

        header: Text {
            text: "EVENTS"
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize1
            color: Theme.textSecondary
            padding: 15
        }

        delegate: EventItem {
            property real timeStmp: timeStamp

            theme: Evnt.typeToEvnt(type).color
            descriptionText: description
            timeText: Utils.durationText(timeStamp)
            selected: ListView.isCurrentItem
            iconSource: "qrc:/ui/ui/icons/" + Evnt.typeToEvnt(type).iconName

            MouseArea {
                id: mouse

                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onClicked: {
                    Context.selectedEvent = index;
                    Context.mediaPlayer.position = timeStamp - 3000;
                }
            }

        }

    }

}
