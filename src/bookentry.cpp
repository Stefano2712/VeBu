/****************************************************************************
**
** Copyright (C) 2023 S. Hornstein
** Contact: http://www.vereinsbuchhaltung.org
**
** This file is part of VeBu Buchhaltungssoftware
**
** GNU General Public License Usage
** This file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
****************************************************************************/
#include "bookentry.h"

BookEntry::BookEntry(QObject *parent)
    : QObject{parent}
    , m_id(-1)
    , m_konto(0)
    , m_gkonto(0)
    , m_beleg("")
    , m_description("")
    , m_datum()
    , m_lastchanged()
    , m_set(0)
{

}

int BookEntry::id() const {
    return m_id;
}

int BookEntry::wert() const {
    return m_wert;
}

int BookEntry::konto() const {
    return m_konto;
}

int BookEntry::gkonto() const {
    return m_gkonto;
}

QString BookEntry::beleg() const {
    return m_beleg;
}

QString BookEntry::description() const {
    return m_description;
}

QDate BookEntry::datum() const {
    return m_datum;
}

int BookEntry::set() const {
    return m_set;
}

QDate BookEntry::lastchanged() const {
    return m_lastchanged;
}

void BookEntry::setWert(const int value) {
    if(m_wert != value) {
      m_wert = value;
      emit wertChanged();
    }
}

void BookEntry::setId(const int value) {
    if(m_id != value) {
      m_id = value;
      emit idChanged();
    }
}

void BookEntry::setKonto(const int value) {
    if(m_konto != value) {
      m_konto = value;
      emit kontoChanged();
    }
}

void BookEntry::setGkonto(const int value) {
    if(m_gkonto != value) {
      m_gkonto = value;
      emit gkontoChanged();
    }
}

void BookEntry::setBeleg(const QString& value) {
    if(m_beleg != value) {
      m_beleg = value;
      emit belegChanged();
    }
}

void BookEntry::setdescription(const QString& value) {
    if(m_description != value) {
      m_description = value;
      emit descriptionChanged();
    }
}

void BookEntry::setDatum(const QDate& value) {
    if(m_datum != value) {
      m_datum = value;
      emit datumChanged();
    }
}

void BookEntry::setLastchanged(const QDate& value) {
    if(m_lastchanged != value) {
      m_lastchanged = value;
      emit lastchangedChanged();
    }
}

void BookEntry::setSet(const int value) {
    if(m_set != value) {
      m_set = value;
      emit setChanged();
    }
}
