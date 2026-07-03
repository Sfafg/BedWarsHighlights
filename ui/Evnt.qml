import QtQuick
pragma Singleton

QtObject {
    property var kill: ({
        "color": Theme.tickRed,
        "size": 6,
        "iconName": "GiOverkill.svg"
    })
    property var finalKill: ({
        "color": Theme.tickDarkRed,
        "size": 8,
        "iconName": "GiOverkill.svg"
    })
    property var death: ({
        "color": Theme.tickGray,
        "size": 6,
        "iconName": "GiDeathSkull.svg"
    })
    property var finalDeath: ({
        "color": Theme.tickWhite,
        "size": 8,
        "iconName": "GiDeathSkull.svg"
    })
    property var win: ({
        "color": Theme.tickGreen,
        "size": 10,
        "iconName": "FaSmileWink.svg"
    })
    property var loss: ({
        "color": Theme.tickBlue,
        "size": 10,
        "iconName": "RiEmotionSadFill.svg"
    })
    property var lostBed: ({
        "color": Theme.tickYellow,
        "size": 10,
        "iconName": "TbBedOff.svg"
    })
    property var bedDestroyed: ({
        "color": Theme.tickCrimson,
        "size": 8,
        "iconName": "FaBed.svg"
    })
    property var gameStart: ({
        "color": Theme.tickPurple,
        "size": 10,
        "iconName": "MdStart.svg"
    })

    function typeToEvnt(type) {
        switch (type) {
        case 0:
            return kill;
        case 1:
            return finalKill;
        case 2:
            return death;
        case 3:
            return finalDeath;
        case 4:
            return win;
        case 5:
            return loss;
        case 6:
            return lostBed;
        case 7:
            return bedDestroyed;
        case 8:
            return gameStart;
        }
        return kill;
    }

}
