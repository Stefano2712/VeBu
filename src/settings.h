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
#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT

signals:
    void userDataChanged(QStringList data);
    void accountListChanged(QStringList data);

public:
    explicit Settings(QObject *parent = nullptr);

public slots:
    Q_INVOKABLE void getUserData(void);
    Q_INVOKABLE void getAccountList(void);
    Q_INVOKABLE void updateAccount(const QString &text1, const int type, const int value);
    Q_INVOKABLE void updateUserData(const QString &text1, const int type);
};

#endif // SETTINGS_H
