import QtQuick
import Quickshell
pragma Singleton

QtObject {
    property string dbPath: Quickshell.dataPath("usage.json")
    property var usage: ({
    })

    function load() {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "file://" + dbPath);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                try {
                    usage = JSON.parse(xhr.responseText || "{}");
                } catch (e) {
                    usage = {
                    };
                }
            }
        };
        xhr.send();
    }

    function save() {
        const xhr = new XMLHttpRequest();
        xhr.open("PUT", "file://" + dbPath);
        xhr.send(JSON.stringify(usage));
    }

    function record(appName) {
        if (!usage[appName])
            usage[appName] = 0;

        usage[appName] += 1;
        save();
    }

    Component.onCompleted: load()
}
