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
#ifndef BOOKSET_H
#define BOOKSET_H

#include <QObject>

class BookSet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int konto READ konto WRITE setKonto NOTIFY kontoChanged)
    Q_PROPERTY(int month READ month WRITE setMonth NOTIFY monthChanged)
    Q_PROPERTY(int year READ year WRITE setYear NOTIFY yearChanged)

public:
    explicit BookSet(QObject *parent = nullptr);

public slots: // slots are public methods available in QML!


signals:
 void idChanged();
 void kontoChanged();
 void monthChanged();
 void yearChanged();

public:
 int id() const;
 int konto() const;
 int month() const;
 int year() const;

 void setId(const int id);
 void setKonto(const int k);
 void setMonth(const int m);
 void setYear(const int y);

private:
 int m_id;
 int m_konto;
 int m_month;
 int m_year;
};

#endif // BOOKSET_H
