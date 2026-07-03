extern "C" {
#include <libavformat/avformat.h>
}
#include <iostream>
#include <string>
#include <chrono>
#include <sstream>
#include "Video.h"

Video::Video(const char *path) {
    AVFormatContext *ctx = nullptr;

    startTime = 0;
    duration = 0;

    if (avformat_open_input(&ctx, path, nullptr, nullptr) != 0) return;
    if (avformat_find_stream_info(ctx, nullptr) < 0) {
        avformat_close_input(&ctx);
        return;
    }

    duration = ceil((ctx->duration != AV_NOPTS_VALUE) ? ctx->duration / (double)AV_TIME_BASE : 0);
    avformat_close_input(&ctx);

    std::string pathStr = std::string(path);
    size_t pos = pathStr.find_last_of("/\\");
    if (pos != std::string::npos) {
        std::stringstream ss(pathStr.substr(pos + 1));

        int Y, M, D, h, m, s;
        ss >> Y >> M >> D >> h >> m >> s;

        startTime = abs(h) * 3600 + abs(m) * 60 + abs(s);

        std::tm t = {};
        t.tm_mday = abs(D);
        t.tm_mon = abs(M) - 1;
        t.tm_year = Y - 1900;
        t.tm_hour = 0;
        t.tm_min = 0;
        t.tm_sec = 0;
        t.tm_isdst = -1;

        std::time_t tt = std::mktime(&t);
        auto sec = std::chrono::system_clock::from_time_t(tt).time_since_epoch();
        day = std::chrono::duration_cast<std::chrono::days>(sec).count();
        startTime += day * 86400;
    }
}
