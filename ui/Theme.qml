import QtQuick
pragma Singleton

QtObject {
    // property color tickGameStart: Qt.hsva(0.53, 0.72, 0.82)

    property color selectedBorder: Qt.rgba(1, 1, 1, 1)
    property int selectedBorderWidth: 2
    property color background: Qt.rgba(0.0392, 0.0392, 0.0471)
    property color primary: Qt.hsva(0, 0, 0.8, 1)
    property color primary1: Qt.hsva(0, 0, 0.6, 1)
    property color primary2: Qt.hsva(0, 0, 0.15, 1)
    property color primary3: Qt.hsva(0, 0, 0.1, 1)
    property color primary4: Qt.rgba(0.071, 0.071, 0.071, 0.9)
    property color accent: Qt.hsva(0.105, 0.55, 0.6, 1)
    property color accent1: Qt.hsva(accent.hsvHue, accent.hsvSaturation, accent.hsvValue, 0.5)
    property color accent2: Qt.hsva(accent.hsvHue, accent.hsvSaturation, accent.hsvValue, 0.2)
    property color text: Qt.hsva(0, 0, 1, 1)
    property color text1: Qt.hsva(0, 0, 0.7, 1)
    property color textInverted: Qt.hsva(0, 0, 0, 1)
    property color textSecondary: Qt.hsva(0, 0, 0.4, 1)
    property color textSecondaryInverted: Qt.hsva(0, 0, 0.2, 1)
    property color textOutline: Qt.hsva(0, 0, 0, 0)
    property color text1Outline: Qt.hsva(0, 0, 0.2, 1)
    property color tickBlue: Qt.hsva(0.65, 0.47, 0.6)
    property color tickGreen: Qt.hsva(0.44, 0.73, 0.51)
    property color tickYellow: Qt.hsva(0.12, 0.83, 0.61)
    property color tickRed: Qt.hsva(1, 0.53, 0.6)
    property color tickCrimson: Qt.hsva(0.98, 0.72, 0.76) // Crimson
    property color tickPurple: Qt.hsva(0.78, 0.68, 0.78) // Purple
    property color tickWhite: Qt.hsva(0, 0, 0.9) // Dark Gray
    property color tickGray: Qt.hsva(0, 0, 0.6) // Dark Gray
    property color tickGold: Qt.hsva(0.13, 0.82, 0.92) // Gold
    property color tickOrange: Qt.hsva(0.08, 0.78, 0.82) // Orange
    property color tickBrown: Qt.hsva(0.09, 0.55, 0.55) // Brown
    property color tickDarkRed: Qt.hsva(0.98, 0.82, 0.58) // Dark Red
}
