import QtQuick

Rectangle {
    z: 10
    implicitHeight: 30
    implicitWidth: 300
    color: "transparent"

    Repeater {
        id: repeater

        model: backend.events

        delegate: EventTick {
            property real timeStmp: timeStamp

            visible: Context.activeFilters.indexOf(type) !== -1
            x: parent.width * timeStamp / Utils?.duration()
            size: Evnt.typeToEvnt(type).size
            color: Evnt.typeToEvnt(type).color
            toolTip.eventText: typeName
            toolTip.descriptionText: description
            toolTip.timeText: Utils.durationText(timeStamp)
            onClick: function() {
                Context.mediaPlayer.position = timeStmp - 3000;
                Context.selectedEvent = index;
            }
        }

    }

    Shortcut {
        sequence: "Ctrl+H"
        onActivated: {
            for (let i = Context.selectedEvent - 1; i >= 0; --i) {
                const e = repeater.itemAt(i);
                if (e.visible && (Context.selectedEvent == -1 || e.timeStmp != repeater.itemAt(Context.selectedEvent).timeStmp)) {
                    e.onClick();
                    break;
                }
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+L"
        onActivated: {
            for (let i = Context.selectedEvent + 1; i < repeater.count; ++i) {
                const e = repeater.itemAt(i);
                if (e.visible && (Context.selectedEvent == -1 || e.timeStmp != repeater.itemAt(Context.selectedEvent).timeStmp)) {
                    e.onClick();
                    break;
                }
            }
        }
    }

}
