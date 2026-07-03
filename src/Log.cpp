#include "Log.h"
#include <stdexcept>
#include <fstream>
#include <sstream>
#include <iostream>
#include <vector>
#include <string>
#include <filesystem>

namespace fs = std::filesystem;

int GetLogCreationDay(const char *logPath) {
    std::string date = fs::path(logPath).stem().stem();
    if (date == "latest") {
        auto sec = std::chrono::system_clock::now().time_since_epoch();
        auto days = std::chrono::duration_cast<std::chrono::days>(sec).count();
        return days - 1;
    }

    size_t pos = date.rfind('-');
    if (pos != std::string::npos) date.erase(pos);

    std::tm tm = {};
    std::stringstream ss(date);
    ss >> std::get_time(&tm, "%Y-%m-%d");
    auto sec = std::chrono::system_clock::from_time_t(std::mktime(&tm)).time_since_epoch();
    auto days = std::chrono::duration_cast<std::chrono::days>(sec).count();
    return days;
}
std::vector<Log> GetLogsForDay(const char *logDir, int day) {
    std::vector<Log> result;

    for (const auto &entry : fs::directory_iterator(logDir)) {
        int creationDay = GetLogCreationDay(entry.path().c_str());
        if (abs(creationDay - day) <= 1) { result.push_back(Log(entry.path().c_str())); }
    }

    return result;
}

std::string decompressGzip(const std::string &input) {
    z_stream zs{};
    zs.next_in = (Bytef *)input.data();
    zs.avail_in = input.size();

    if (inflateInit2(&zs, 16 + MAX_WBITS) != Z_OK) { throw std::runtime_error("inflateInit failed"); }

    std::string output;
    char buffer[32768];

    int ret;
    do {
        zs.next_out = (Bytef *)buffer;
        zs.avail_out = sizeof(buffer);

        ret = inflate(&zs, 0);

        if (output.size() < zs.total_out) { output.append(buffer, zs.total_out - output.size()); }

    } while (ret == Z_OK);

    inflateEnd(&zs);

    if (ret != Z_STREAM_END) { throw std::runtime_error("gzip decompression failed"); }

    return output;
}

Log::Log(const std::string &path) {
    std::ifstream logFile(path);
    std::stringstream ss;
    ss << logFile.rdbuf();

    if (path.ends_with(".log")) contents = ss.str();
    else contents = decompressGzip(ss.str());
    day = GetLogCreationDay(path.c_str());
}
