#include <QObject>
#include <QUrl>
#include "EventsModel.h"

class Backend : public QObject {
    Q_OBJECT
    Q_PROPERTY(EventModel *events READ events NOTIFY eventsChanged)
    Q_PROPERTY(QUrl videoPath READ videoPath WRITE setVideoPath NOTIFY videoPathChanged)

  public:
    explicit Backend(QObject *parent = nullptr);
    EventModel *events();
    QUrl videoPath() const;
    void setVideoPath(const QUrl &path);

  signals:
    void eventsChanged();
    void videoPathChanged();

  private:
    EventModel m_events;
    QUrl m_videoPath;
};
