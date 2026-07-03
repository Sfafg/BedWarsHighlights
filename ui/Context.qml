import QtMultimedia
import QtQuick
pragma Singleton

QtObject {
    property MediaPlayer mediaPlayer
    property bool fullScreen: false
    property int selectedEvent: -1
}
