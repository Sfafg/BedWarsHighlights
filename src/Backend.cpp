#include <iostream>
#include <qdatetime.h>
#include <string>
#include <chrono>
#include <QDebug>
#include <sstream>
#include <QVariant>
#include <format>
#include <filesystem>
#include "Log.h"
#include "Video.h"
#include "Events.h"
#include "Backend.h"
using namespace std::chrono_literals;

bool GenerateKeyframe(const std::string &path, const std::string &name, int second) {
    std::filesystem::create_directories("thumbnails");
    std::filesystem::create_directories(std::format("thumbnails/{}", name));
    std::string outPath = std::format("thumbnails/{}/frame_{}.jpg", name, second);
    if (std::filesystem::exists(outPath)) return true;

    std::string command = std::format(
        "ffmpeg -ss {} -hwaccel vaapi -y -i \"{}\" -frames:v 1 -vf crop=iw-1080:ih:0:0,scale=-2:90 {} > /dev/null "
        "2>&1",
        second, path, outPath
    );
    system(command.c_str());
    return std::filesystem::exists(outPath);
}

Backend::Backend(QObject *parent) : QObject(parent) {
    for (int i = 0; i < keyFrameThreads.size(); i++) {

        keyFrameThreads[i] = std::thread([this]() {
            auto *init = &m_keyFramesToGenerate;
            while (true) {
                int timeStamp;
                std::string path;
                std::string fileName;
                {
                    generationMutex.lock();
                    if (m_keyFramesToGenerate.empty()) {
                        generationMutex.unlock();
                        std::this_thread::sleep_for(50ms);
                        continue;
                    }
                    timeStamp = m_keyFramesToGenerate.front();
                    m_keyFramesToGenerate.pop_front();
                    path = m_videoPath.toString().toStdString();
                    fileName = m_videoPath.fileName().toStdString();
                    generationMutex.unlock();
                }

                for (auto &c : fileName)
                    if (c == ' ') c = '_';
                bool succeded = GenerateKeyframe(path, fileName, timeStamp / 1000);

                // qDebug() << (succeded ? "Generated " : "Failed ") << timeStamp;
                if (succeded) emit keyFrameChanged(timeStamp);
            }
        });
    }

    m_videoDuration = 0;
    emit videoDurationChanged();
    m_timer.setInterval(50);
    connect(&m_timer, &QTimer::timeout, this, [this]() {
        setVideoDuration(1);
        emit videoDurationChanged();
    });
}
EventModel *Backend::events() { return &m_events; }

Q_INVOKABLE bool Backend::isValidPath(const QUrl &path) const {
    return std::filesystem::exists(path.toString().toStdString());
}
QString Backend::videoPathFileName() const {
    auto fileName = m_videoPath.fileName();
    for (auto &c : fileName)
        if (c == ' ') c = '_';
    return fileName;
}
Q_INVOKABLE QUrl Backend::videoPath() const { return m_videoPath; }
void Backend::setVideoPath(const QUrl &path) {
    if (path == m_videoPath) return;
    generationMutex.lock();
    m_videoDuration = 0;
    m_timer.start();
    m_videoPath = path;
    m_keyFramesToGenerate.clear();
    generationMutex.unlock();

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

Q_INVOKABLE void Backend::addKeyFrameGenerationJob(int timestamp) {
    std::lock_guard<std::mutex> lock(generationMutex);
    m_keyFramesToGenerate.push_back(timestamp);
}
Q_INVOKABLE void Backend::removeKeyFrameGenerationJob(int timestamp) {
    std::lock_guard<std::mutex> lock(generationMutex);
    auto it = std::find(m_keyFramesToGenerate.begin(), m_keyFramesToGenerate.end(), timestamp);
    if (it != m_keyFramesToGenerate.end()) m_keyFramesToGenerate.erase(it);
}
