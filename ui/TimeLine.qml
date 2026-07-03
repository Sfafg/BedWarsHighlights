import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property var activeFilters: [0, 1, 2, 3, 4, 5, 6, 7, 8]

    Layout.fillWidth: true

    PlayerControls {
    }

    RowLayout {
        visible: !Context.fullScreen

        Text {
            padding: 10
            text: "Filter:"
            color: Theme.textSecondary
            font.family: Fnt.fontFamily
            font.pixelSize: Fnt.fontSize3
        }

        FilterItem {
            id: filter0

            filterText: "Kill"
            iconColor: Evnt.kill.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.kill.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 0;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "1"
                onActivated: filter0.onClick()
            }

        }

        FilterItem {
            id: filter1

            filterText: "FinalKill"
            iconColor: Evnt.finalKill.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.finalKill.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 1;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "2"
                onActivated: filter1.onClick()
            }

        }

        FilterItem {
            id: filter2

            filterText: "Death"
            iconColor: Evnt.death.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.death.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 2;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "3"
                onActivated: filter2.onClick()
            }

        }

        FilterItem {
            id: filter3

            filterText: "FinalDeath"
            iconColor: Evnt.finalDeath.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.finalDeath.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 3;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "4"
                onActivated: filter3.onClick()
            }

        }

        FilterItem {
            id: filter4

            filterText: "Win"
            iconColor: Evnt.win.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.win.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 4;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "5"
                onActivated: filter4.onClick()
            }

        }

        FilterItem {
            id: filter5

            filterText: "Loss"
            iconColor: Evnt.loss.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.loss.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 5;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "6"
                onActivated: filter5.onClick()
            }

        }

        FilterItem {
            id: filter6

            filterText: "LostBed"
            iconColor: Evnt.lostBed.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.lostBed.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 6;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "7"
                onActivated: filter6.onClick()
            }

        }

        FilterItem {
            id: filter7

            filterText: "BedDestroyed"
            iconColor: Evnt.bedDestroyed.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.bedDestroyed.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 7;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "8"
                onActivated: filter7.onClick()
            }

        }

        FilterItem {
            id: filter8

            filterText: "GameStart"
            iconColor: Evnt.gameStart.color
            iconSource: "qrc:/ui/ui/icons/" + Evnt.gameStart.iconName
            onClick: function() {
                isActive = !isActive;
                let id = 8;
                let i = root.activeFilters.indexOf(id);
                if (i === -1)
                    root.activeFilters.push(id);
                else
                    root.activeFilters.splice(i, 1);
                root.activeFiltersChanged();
            }

            Shortcut {
                sequence: "9"
                onActivated: filter8.onClick()
            }

        }

    }

    Item {
        visible: !Context.fullScreen
        Layout.fillWidth: true
        Layout.leftMargin: 20
        Layout.rightMargin: 20
        implicitHeight: 45
        z: 1

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

        Repeater {
            id: repeater

            model: backend.events

            delegate: EventTick {
                property real timeStmp: timeStamp

                visible: root.activeFilters.indexOf(type) !== -1
                x: parent.width * timeStamp / Context.mediaPlayer.duration
                size: Evnt.typeToEvnt(type).size
                color: Evnt.typeToEvnt(type).color
                toolTip.eventText: typeName
                toolTip.descriptionText: description
                toolTip.timeText: Utils.durationText(timeStamp)
                onClick: function() {
                    Context.mediaPlayer.position = Context.mediaPlayer.duration * x / parent.width;
                    Context.selectedEvent = index;
                }
            }

        }

    }

    SeekBar {
        visible: !Context.fullScreen
        Layout.fillWidth: true
        Layout.leftMargin: 20
        Layout.rightMargin: 20
    }

    Item {
        visible: !Context.fullScreen
        height: 50
    }

}
