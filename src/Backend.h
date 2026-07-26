#include <QObject>
#include <QUrl>
#include <QTimer>
#include "EventsModel.h"
#include <deque>
#include <thread>
#include <mutex>

class Backend : public QObject {
    Q_OBJECT
    Q_PROPERTY(EventModel *events READ events NOTIFY eventsChanged)
    Q_PROPERTY(QUrl videoPath READ videoPath WRITE setVideoPath NOTIFY videoPathChanged)
    Q_PROPERTY(qint64 videoDuration READ videoDuration WRITE setVideoDuration NOTIFY videoDurationChanged)

  public:
    explicit Backend(QObject *parent = nullptr);
    EventModel *events();

    Q_INVOKABLE bool isValidPath(const QUrl &path) const;
    Q_INVOKABLE QString videoPathFileName() const;
    QUrl videoPath() const;
    void setVideoPath(const QUrl &path);

    qint64 videoDuration() const;
    void setVideoDuration(qint64 duration);

    Q_INVOKABLE void addKeyFrameGenerationJob(int timestamp);
    Q_INVOKABLE void removeKeyFrameGenerationJob(int timestamp);

  signals:
    void eventsChanged();
    void keyFrameChanged(int);
    void videoPathChanged();
    void videoDurationChanged();

  private:
    QTimer m_timer;
    EventModel m_events;
    QUrl m_videoPath;
    qint64 m_videoDuration = 0;
    std::deque<int> m_keyFramesToGenerate;
    std::array<std::thread, 2> keyFrameThreads;
    std::mutex generationMutex;
};
