#pragma once

#include <QAbstractListModel>
#include <vector>
#include "Events.h"

class EventModel : public QAbstractListModel {
    Q_OBJECT

  public:
    enum Roles { TypeRole = Qt::UserRole + 1, TypeNameRole, TimeStampRole, DescriptionRole };

    explicit EventModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    void addEvent(const Event &e);

    void clear();

    const std::vector<Event> &events() const;

  private:
    std::vector<Event> m_events;
};
