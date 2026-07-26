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

    function duration() {
        if (Context.mediaPlayer.duration == 0)
            return backend.videoDuration;

        return Context.mediaPlayer.duration;
    }

    function calculateTimeTickDistance(visibleDuration) {
        const scales = [1, 2, 5, 10, 15, 30];
        const ideal = visibleDuration / 15;
        const minutePower = Math.pow(60, Math.floor(Math.log(ideal / 1000) / Math.log(60)));
        const base = minutePower * 1000;
        for (const s of scales) {
            if (base * s >= ideal)
                return base * s;

        }
        return base * 60;
    }

    function floorTo(x, num) {
        return Math.floor(x / num) * num;
    }

}
