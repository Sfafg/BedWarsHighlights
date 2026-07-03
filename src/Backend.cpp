#include <QVariant>
#include "Log.h"
#include "Video.h"
#include "Events.h"
#include "Backend.h"

Backend::Backend(QObject *parent) : QObject(parent) {}
EventModel *Backend::events() { return &m_events; }
QUrl Backend::videoPath() const { return m_videoPath; }
void Backend::setVideoPath(const QUrl &path) {
    if (path == m_videoPath) return;
    m_videoPath = path;

    const std::string logDirectory = "/home/slawek/Crystal-Launcher/instances/u.pvp/.minecraft/logs/";
    const std::string playerNicknames[] = {"Sfafg27", "Ersit", "Delxwel"};
    Video video(m_videoPath.toString().toStdString().c_str());
    auto logs = GetLogsForDay(logDirectory.c_str(), video.day);
    std::vector<Event> events = ParseEvents(logs, video.day);

    for (int i = events.size() - 1; i >= 0; i--) {
        if (events[i].timeStamp < video.startTime || events[i].timeStamp > video.startTime + video.duration) {
            events.erase(events.begin() + i);
            continue;
        }

        if (events[i].type == Event::Type::Kill || events[i].type == Event::Type::FinalKill ||
            events[i].type == Event::Type::Death || events[i].type == Event::Type::FinalDeath ||
            events[i].type == Event::Type::BedDestroyed) {

            if (!std::ranges::any_of(playerNicknames, [&](const auto &s) {
                    return events[i].description.find(s) != std::string::npos;
                })) {
                events.erase(events.begin() + i);
                continue;
            }
        }
        events[i].timeStamp = (events[i].timeStamp - video.startTime) * 1000;
    }

    this->events()->clear();
    for (const auto &e : events) this->events()->addEvent(e);
    emit videoPathChanged();
}
