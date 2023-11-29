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
#ifndef ACCOUNTENTRY_H
#define ACCOUNTENTRY_H

#include <QObject>

class AccountEntry : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(QString description READ description WRITE setdescription NOTIFY descriptionChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
public:
    explicit AccountEntry(QObject *parent = nullptr);

    static void setDefaultList(QList<AccountEntry*> &alist);

public slots: // slots are public methods available in QML!



signals:
 void descriptionChanged();
 void numberChanged();
 void typeChanged();

public:
 QString description() const;
 QString type() const;
 int number() const;
 void setdescription(const QString& value);
 void setNumber(const int value);
 void setType(const QString& value);

private:
 int m_number;
 QString m_description;
 QString m_type;
};

#endif
