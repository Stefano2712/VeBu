#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
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
#include "accountentry.h"
#include "bookset.h"

class VebuDatabase {

private:
    QSqlDatabase db;
    static VebuDatabase *instance;

    VebuDatabase() {

        db = QSqlDatabase::addDatabase("QSQLITE");

        // TODO: Datenbank Pfad Einstellbar machen!
#ifdef Q_OS_WIN
        db.setDatabaseName("C:/Users/Administrator/Documents/vebu.db");
#else
        db.setDatabaseName("/Users/airm1/Documents/vebu.db");
#endif
        if (!db.open()) {
            qDebug() << "Fehler beim Öffnen der Datenbank!";
        }
    }

public:
    static VebuDatabase *getInstance() {
        if (!instance) {
            instance = new VebuDatabase();
        }
        return instance;
    }

    void addAccount(AccountEntry &name);
    void addSet(BookSet &name);
    void addBooking(BookEntry &name);
    void addUserData(const QString &name, const int type);

    void loadAccountData(QList<AccountEntry*> &accountList);
    void loadBookingsForSet(int id, QList<BookEntry*> &bookingslist);
    void loadBookingsForYear(int year, QList<BookEntry*> &bookingslist);
    void loadSetsForYear(int year, QList<BookSet*> &setlist);
    void loadUserData(QStringList &name);

    void createTables(void);

    ~VebuDatabase() {
        db.close();
    }
};

#endif // DATABASE_H
