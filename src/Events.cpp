#include "Events.h"
#include <QGuiApplication>
#include <sstream>
#include <regex>

const char *Event::TypeNames[] = {"Kill", "FinalKill", "Death",        "FinalDeath", "Win",
                                  "Loss", "LostBed",   "BedDestroyed", "GameStart"};

bool Event::operator==(const Event &o) const {
    return type == o.type && timeStamp == o.timeStamp && description == o.description;
}

std::ostream &operator<<(std::ostream &os, const Event::Type &e) { return os << Event::TypeNames[(int)e]; }

int GetTimeStamp(const std::string &str) {
    std::regex timeRegex(R"(^\[([0-9]*):([0-9]*):([0-9]*)\])");
    std::smatch match;
    if (std::regex_search(str, match, timeRegex)) {

        int hours = std::stoi(match[1]);
        int minutes = std::stoi(match[2]);
        int seconds = std::stoi(match[3]);

        return hours * 3600 + minutes * 60 + seconds;
    }
    return 0;
}

std::vector<Event> ParseLog(const std::string &str, std::string &teamColor) {
    // Final death????
    std::vector<Event> events;

    std::stringstream ss(str);
    std::string line;

    std::regex teamColorRegex(R"(BedWars ► (?:You and your party|You) are now in team ([a-zA-Z]*))");
    std::regex gameStartRegex(R"(\[CHAT\]                   Goodluck with your BedWars Game)");
    std::regex finalKillRegex(R"(\[CHAT\] ([_a-zA-Z0-9]+) has been killed by ([_a-zA-Z0-9]+) FINAL KILL)");
    std::regex killRegex(R"(\[CHAT\] ([_a-zA-Z0-9]+) has been killed by ([_a-zA-Z0-9]+))");
    std::regex deathRegex(R"(\[CHAT\] ([_a-zA-Z0-9]+) died)");
    std::regex bedDestroyedRegex(R"(\[CHAT\] ([a-zA-Z]+) Team's Bed .* by ([_a-zA-Z0-9]+))");
    std::regex teamEliminationRegex(R"(\[CHAT\] ⚠ Team ([a-zA-Z]+) has been eliminated from the game!)");
    std::regex teamWonRegex(R"( \[CHAT\]                           ([a-zA-Z]+) won the game!)");

    while (std::getline(ss, line)) {
        std::smatch match;
        if (std::regex_search(line, match, teamColorRegex)) teamColor = match[1];
        else if (std::regex_search(line, gameStartRegex)) {
            events.push_back(Event{Event::Type::GameStart, GetTimeStamp(line), "Starting as " + teamColor});
        } else if (std::regex_search(line, match, finalKillRegex)) {
            events.push_back(
                Event{
                    Event::Type::FinalKill, GetTimeStamp(line),
                    match[2].str() + " killed " + match[1].str() + " finall kill"
                }
            );
        } else if (std::regex_search(line, match, killRegex)) {
            events.push_back(
                Event{Event::Type::Kill, GetTimeStamp(line), match[2].str() + " killed " + match[1].str()}
            );
        } else if (std::regex_search(line, match, deathRegex)) {
            events.push_back(Event{Event::Type::Death, GetTimeStamp(line), match[1].str() + " died"});
        } else if (std::regex_search(line, match, bedDestroyedRegex)) {
            if (match[1].str() == teamColor)
                events.push_back(
                    Event{Event::Type::LostBed, GetTimeStamp(line), match[2].str() + " destroyed our bed"}
                );
            else
                events.push_back(
                    Event{Event::Type::BedDestroyed, GetTimeStamp(line), match[2].str() + " destroyed a bed"}
                );
        } else if (std::regex_search(line, match, teamEliminationRegex)) {
            if (match[1].str() == teamColor)
                events.push_back(Event{Event::Type::Loss, GetTimeStamp(line), "Game Lost"});
        } else if (std::regex_search(line, match, teamEliminationRegex)) {
            if (match[1].str() == teamColor)
                events.push_back(Event{Event::Type::Loss, GetTimeStamp(line), "Game Lost"});
        } else if (std::regex_search(line, match, teamWonRegex)) {
            if (match[1].str() == teamColor) events.push_back(Event{Event::Type::Win, GetTimeStamp(line), "Game Won"});
        }
    }

    return events;
}
std::vector<Event> ParseEvents(const std::vector<Log> &logs, int day) {
    std::vector<Event> results;
    std::string teamColor;
    for (auto &l : logs) {
        std::vector<Event> evnt = ParseLog(l.contents, teamColor);
        for (auto &e : evnt) e.timeStamp += l.day * 86400;
        results.append_range(evnt);
    }
    return results;
}
