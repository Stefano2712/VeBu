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
#ifndef BOOKENTRY_H
#define BOOKENTRY_H

#include <QObject>
#include <QDate>

class BookEntry : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int wert READ wert WRITE setWert NOTIFY wertChanged)
    Q_PROPERTY(int konto READ konto WRITE setKonto NOTIFY kontoChanged)
    Q_PROPERTY(int gkonto READ gkonto WRITE setGkonto NOTIFY gkontoChanged)
    Q_PROPERTY(QString beleg READ beleg WRITE setBeleg NOTIFY belegChanged)
    Q_PROPERTY(QString description READ description WRITE setdescription NOTIFY descriptionChanged)
    Q_PROPERTY(QDate datum READ datum WRITE setDatum NOTIFY datumChanged)
    Q_PROPERTY(QDate lastchanged READ lastchanged WRITE setLastchanged NOTIFY lastchangedChanged)
    Q_PROPERTY(int m_set READ set WRITE setSet NOTIFY setChanged)

public:
    explicit BookEntry(QObject *parent = nullptr);

public slots: // slots are public methods available in QML!


signals:
 void idChanged();
 void wertChanged();
 void kontoChanged();
 void gkontoChanged();
 void belegChanged();
 void descriptionChanged();
 void datumChanged();
 void lastchangedChanged();
 void setChanged();

public:
 int id() const;
 int wert() const;
 int konto() const;
 int gkonto() const;
 QString beleg() const;
 QString description() const;
 QDate datum() const;
 QDate lastchanged() const;
 int set() const;

 void setId(const int value);
 void setWert(const int value);
 void setKonto(const int value);
 void setGkonto(const int value);
 void setBeleg(const QString& value);
 void setdescription(const QString& value);
 void setDatum(const QDate& value);
 void setLastchanged(const QDate& value);
 void setSet(const int value);

private:
 int m_id;
 int m_wert;
 int m_konto;
 int m_gkonto;
 QString m_beleg;
 QString m_description;
 QDate m_datum;
 QDate m_lastchanged;
 int m_set;
};

#endif // BOOKENTRY_H
