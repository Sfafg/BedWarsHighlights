import QtMultimedia
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

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
                isActive: Context.activeFilters.includes(index)
                onClick: function(left) {
                    if (!left) {
                        if (isActive) {
                            Context.activeFilters = [0, 1, 2, 3, 4, 5, 6, 7, 8];
                            Context.activeFilters.splice(index, 1);
                        } else {
                            Context.activeFilters = [index];
                        }
                        Context.activeFiltersChanged();
                        return ;
                    }
                    let i = Context.activeFilters.indexOf(index);
                    if (i === -1)
                        Context.activeFilters.push(index);
                    else
                        Context.activeFilters.splice(i, 1);
                    Context.activeFiltersChanged();
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
        implicitHeight: 70
        Layout.fillWidth: true
        Layout.leftMargin: 20
        Layout.rightMargin: 20
        Layout.alignment: Qt.AlignBottom

        SeekBar {
        }

    }

    Item {
        visible: !Context.fullScreen
        height: 110
    }

}
