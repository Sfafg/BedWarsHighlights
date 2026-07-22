#include <iostream>
#include <qdatetime.h>
#include <string>
#include <chrono>
#include <sstream>
#include <QVariant>
#include "Log.h"
#include "Video.h"
#include "Events.h"
#include "Backend.h"

Backend::Backend(QObject *parent) : QObject(parent) {
    m_timer.setInterval(50);
    m_timer.start();
    connect(&m_timer, &QTimer::timeout, this, [this]() {
        setVideoDuration(1);
        emit videoDurationChanged();
    });
}
EventModel *Backend::events() { return &m_events; }
QUrl Backend::videoPath() const { return m_videoPath; }
void Backend::setVideoPath(const QUrl &path) {
    if (path == m_videoPath) return;
    m_videoPath = path;

    const std::string logDirectory = "/home/slawek/Crystal-Launcher/instances/u.pvp/.minecraft/logs/";
    Video video(m_videoPath.toString().toStdString().c_str());
    auto logs = GetLogsForDay(logDirectory.c_str(), video.day);
    auto [events, party] = ParseEvents(logs, video.day);

    for (int i = events.size() - 1; i >= 0; i--) {
        if (events[i].timeStamp < video.startTime || events[i].timeStamp > video.startTime + video.duration) {
            events.erase(events.begin() + i);
            continue;
        }

        events[i].timeStamp = (events[i].timeStamp - video.startTime) * 1000;
    }

    this->events()->clear();
    for (const auto &e : events) this->events()->addEvent(e);
    emit videoPathChanged();
    setVideoDuration(0);
}

qint64 Backend::videoDuration() const { return m_videoDuration; }
void Backend::setVideoDuration(qint64) {
    std::string pathStr = m_videoPath.toString().toStdString();
    size_t pos = pathStr.find_last_of("/\\");
    qint64 duration = 0;
    if (pos != std::string::npos) {
        std::stringstream ss(pathStr.substr(pos + 1));

        int Y, M, D, h, m, s;
        ss >> Y >> M >> D >> h >> m >> s;

        std::tm t = {};
        t.tm_mday = abs(D);
        t.tm_mon = abs(M) - 1;
        t.tm_year = Y - 1900;
        t.tm_hour = abs(h);
        t.tm_min = abs(m);
        t.tm_sec = abs(s);
        t.tm_isdst = -1;

        std::time_t tt = std::mktime(&t);
        auto sec = std::chrono::system_clock::from_time_t(tt).time_since_epoch();
        qint64 start = std::chrono::duration_cast<std::chrono::milliseconds>(sec).count();
        duration = QDateTime::currentMSecsSinceEpoch() - start - 7000;
    }

    if (m_videoDuration == duration) return;
    m_videoDuration = duration;
}
