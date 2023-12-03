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
#include "settings.h"
#include "database.h"

Settings::Settings(QObject *parent) : QObject(parent)
{
}

void Settings::getUserData(void)
{
    // TODO: Add MandantenNr. later onwards for multiuser usage.
    QStringList newData;
    VebuDatabase* db = VebuDatabase::getInstance();
    db->loadUserData(newData);

    if (newData.size())
    {
        emit userDataChanged(newData);
    }
}

void Settings::updateUserData(const QString &text1, const int type)
{
    VebuDatabase* db = VebuDatabase::getInstance();
    db->addUserData(text1, type);
}

/**
 * Ändere den Wert von einer Eröffnungsbuchung.
 */
void Settings::updateAccount(const QString &text1, const int type, const int value)
{
    VebuDatabase* db = VebuDatabase::getInstance();
    //db->updateAccountData(const int type, const int value);
}
