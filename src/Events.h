#pragma once
#include <string>
#include <vector>
#include <iostream>
#include "Log.h"

struct Event {
    enum class Type { Kill, FinalKill, Death, FinalDeath, Win, Loss, LostBed, BedDestroyed, GameStart };
    static const char *TypeNames[];

    Type type;
    int timeStamp;
    std::string description;
    bool operator==(const Event &o) const;
};

std::ostream &operator<<(std::ostream &os, const Event::Type &e);

std::vector<Event> ParseEvents(const std::vector<Log> &logs, int day);
