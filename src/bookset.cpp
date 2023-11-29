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
#include "bookset.h"

BookSet::BookSet(QObject *parent)
    : QObject{parent}
    , m_id(-1)
    , m_konto(0)
    , m_month(0)
    , m_year(0)
{

}

int BookSet::id() const {
    return m_id;
}

int BookSet::konto() const {
    return m_konto;
}

int BookSet::month() const {
    return m_month;
}

int BookSet::year() const {
    return m_year;
}

void BookSet::setId(const int value) {
    if(m_id != value) {
        m_id = value;
        emit idChanged();
    }
}

void BookSet::setKonto(const int value) {
    if(m_konto != value) {
        m_konto = value;
        emit kontoChanged();
    }
}

void BookSet::setMonth(const int value) {
    if(m_month != value) {
        m_month = value;
        emit monthChanged();
    }
}

void BookSet::setYear(const int value) {
    if(m_year != value) {
        m_year = value;
        emit yearChanged();
    }
}
