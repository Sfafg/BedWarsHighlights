#include <QObject>
#include <QUrl>
#include <QTimer>
#include "EventsModel.h"

class Backend : public QObject {
    Q_OBJECT
    Q_PROPERTY(EventModel *events READ events NOTIFY eventsChanged)
    Q_PROPERTY(QUrl videoPath READ videoPath WRITE setVideoPath NOTIFY videoPathChanged)
    Q_PROPERTY(qint64 videoDuration READ videoDuration WRITE setVideoDuration NOTIFY videoDurationChanged)

  public:
    explicit Backend(QObject *parent = nullptr);
    EventModel *events();
    QUrl videoPath() const;
    void setVideoPath(const QUrl &path);

    qint64 videoDuration() const;
    void setVideoDuration(qint64 duration);

  signals:
    void eventsChanged();
    void videoPathChanged();
    void videoDurationChanged();

  private:
    QTimer m_timer;
    EventModel m_events;
    QUrl m_videoPath;
    qint64 m_videoDuration = 0;
};
