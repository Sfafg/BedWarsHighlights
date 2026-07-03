#pragma once

#include "EventsModel.h"
EventModel::EventModel(QObject *parent) : QAbstractListModel(parent) {}

int EventModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return static_cast<int>(m_events.size());
}

QVariant EventModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_events.size()) return {};

    const Event &e = m_events[index.row()];

    switch (role) {
    case TypeRole: return static_cast<int>(e.type);
    case TypeNameRole: return QString::fromStdString(Event::TypeNames[(int)e.type]);
    case TimeStampRole: return e.timeStamp;
    case DescriptionRole: return QString::fromStdString(e.description);
    default: return {};
    }
}

QHash<int, QByteArray> EventModel::roleNames() const {
    return {
        {TypeRole, "type"},
        {TypeNameRole, "typeName"},
        {TimeStampRole, "timeStamp"},
        {DescriptionRole, "description"}
    };
}

void EventModel::addEvent(const Event &e) {
    beginInsertRows(QModelIndex(), m_events.size(), m_events.size());
    m_events.push_back(e);
    endInsertRows();
}

void EventModel::clear() {
    beginResetModel();
    m_events.clear();
    endResetModel();
}

const std::vector<Event> &EventModel::events() const { return m_events; }
