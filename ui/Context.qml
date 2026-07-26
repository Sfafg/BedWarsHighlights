import QtMultimedia
import QtQuick
pragma Singleton

QtObject {
    property MediaPlayer mediaPlayer
    property bool fullScreen: false
    property int selectedEvent: -1
    property real videoScale: 1
    property var activeFilters: [0, 1, 2, 3, 4, 5, 6, 7, 8]
}
