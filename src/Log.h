#pragma once

#include <zlib.h>
#include <string>
#include <vector>

class Log {
  public:
    std::string contents;
    int day;

    Log(const std::string &path);
};

std::vector<Log> GetLogsForDay(const char *logDir, int day);
