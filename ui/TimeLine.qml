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

        Repeater {
            model: [{
                "name": "Kill",
                "event": Evnt.kill
            }, {
                "name": "FinalKill",
                "event": Evnt.finalKill
            }, {
                "name": "Death",
                "event": Evnt.death
            }, {
                "name": "FinalDeath",
                "event": Evnt.finalDeath
            }, {
                "name": "Win",
                "event": Evnt.win
            }, {
                "name": "Loss",
                "event": Evnt.loss
            }, {
                "name": "LostBed",
                "event": Evnt.lostBed
            }, {
                "name": "BedDestroyed",
                "event": Evnt.bedDestroyed
            }, {
                "name": "GameStart",
                "event": Evnt.gameStart
            }]

            delegate: FilterItem {
                filterText: modelData.name
                iconColor: modelData.event.color
                iconSource: "qrc:/ui/ui/icons/" + modelData.event.iconName
                isActive: root.activeFilters.includes(index)
                onClick: function(left) {
                    if (!left) {
                        if (isActive) {
                            root.activeFilters = [0, 1, 2, 3, 4, 5, 6, 7, 8];
                            root.activeFilters.splice(index, 1);
                        } else {
                            root.activeFilters = [index];
                        }
                        root.activeFiltersChanged();
                        return ;
                    }
                    let i = root.activeFilters.indexOf(index);
                    if (i === -1)
                        root.activeFilters.push(index);
                    else
                        root.activeFilters.splice(i, 1);
                    root.activeFiltersChanged();
                }

                Shortcut {
                    sequence: (index + 1).toString()
                    onActivated: onClick(true)
                }

                Shortcut {
                    sequence: "Shift + " + (index + 1).toString()
                    onActivated: onClick(false)
                }

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
                x: parent.width * timeStamp / (Context.mediaPlayer.duration || backend.videoDuration)
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
