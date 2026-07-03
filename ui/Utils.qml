import QtQuick
pragma Singleton

QtObject {
    function durationText(duration) {
        let sDuration = Math.floor(duration / 1000);
        if (sDuration < 60)
            return "0:" + String(sDuration).padStart(2, "0");

        let mDuration = Math.floor(sDuration / 60);
        sDuration -= mDuration * 60;
        if (mDuration < 60)
            return [mDuration, String(sDuration).padStart(2, "0")].join(":");

        const hDuration = Math.floor(mDuration / 60);
        mDuration -= hDuration * 60;
        return [hDuration, String(mDuration).padStart(2, "0"), String(sDuration).padStart(2, "0")].join(":");
    }

}
