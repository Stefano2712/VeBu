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
#include "database.h"
#include <QSqlRecord>

VebuDatabase* VebuDatabase::instance = nullptr;

void VebuDatabase::addAccount(AccountEntry &entry){
    QSqlQuery query;

    query.prepare("INSERT OR IGNORE INTO Kontenplan "
                  "(ID) "
                  "VALUES (:id)");

    query.bindValue(":id", entry.number());

    if (!query.exec()) {
        qDebug() << "Fehler 1: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    }

    else
    {
        query.prepare("UPDATE Kontenplan "
                      "SET Desc = :desc, Type = :type "
                      "WHERE ID = :id");

        query.bindValue(":id", entry.number());
        query.bindValue(":desc", entry.description());
        query.bindValue(":type", entry.type());

        query.exec();


        if (!query.exec()) {
            qDebug() << "Fehler 1: " << query.lastError().text();
            qDebug() << "Query: " << query.lastQuery();
        }
    }
}

void VebuDatabase::addSet(BookSet &entry){
    QSqlQuery query;

    query.prepare("SELECT * FROM BKreise "
                  "WHERE Konto = :konto AND Monat = :monat AND Jahr = :jahr");

    query.bindValue(":konto", entry.konto());
    query.bindValue(":monat", entry.month());
    query.bindValue(":jahr", entry.year());

    if (!query.exec()) {
        qDebug() << "Fehler 1: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    }

    else
    {
        if (query.next()) {
            entry.setId(query.value("ID").toInt());
        }
    }

    if (entry.id() == -1)
    {
        query.prepare("INSERT INTO BKreise "
                      "(Konto, Monat, Jahr) "
                      "VALUES (:konto, :monat, :jahr)");

        query.bindValue(":konto", entry.konto());
        query.bindValue(":monat", entry.month());
        query.bindValue(":jahr", entry.year());

        if (!query.exec()) {
            qDebug() << "Fehler 1: " << query.lastError().text();
            qDebug() << "Query: " << query.lastQuery();
        }

        else
        {
            query.prepare("SELECT last_insert_rowid() AS ID;");

            if (!query.exec()) {
                qDebug() << "Fehler 1: " << query.lastError().text();
                qDebug() << "Query: " << query.lastQuery();
            }

            else
            {
                if (query.next()) {
                    entry.setId(query.value("ID").toInt());
                }
            }
        }
    }

    else
    {
        query.prepare("UPDATE BKreise "
                      "SET Konto = :konto, Monat = :monat, Jahr = :jahr "
                      "WHERE ID = :id");

        query.bindValue(":id", entry.id());
        query.bindValue(":monat", entry.month());
        query.bindValue(":konto", entry.konto());
        query.bindValue(":jahr", entry.year());

        query.exec();


        if (!query.exec()) {
            qDebug() << "Fehler 1: " << query.lastError().text();
            qDebug() << "Query: " << query.lastQuery();
        }
    }
}

void VebuDatabase::addBooking(BookEntry &entry){
    QSqlQuery query;

    if (entry.id() == -1)
    {
        query.prepare("INSERT INTO Buchungen "
                      "(Wert, Konto, Gegenkonto, Beleg, Beschreibung, Datum, LastChanged, Buchungskreis) "
                      "VALUES (:wert, :konto, :gkonto, :beleg, :beschreibung, :datum, :lastchanged, :buchungskreis)");

        query.bindValue(":wert", entry.wert());
        query.bindValue(":konto", entry.konto());
        query.bindValue(":gkonto", entry.gkonto());
        query.bindValue(":beleg", entry.beleg());
        query.bindValue(":beschreibung", entry.description());
        query.bindValue(":datum", entry.datum());
        query.bindValue(":lastchanged", entry.lastchanged());
        query.bindValue(":buchungskreis", entry.set());

        if (!query.exec()) {
            qDebug() << "Fehler 1: " << query.lastError().text();
            qDebug() << "Query: " << query.lastQuery();
        }

        else
        {
            query.prepare("SELECT last_insert_rowid() AS ID;");

            if (!query.exec()) {
                qDebug() << "Fehler 1: " << query.lastError().text();
                qDebug() << "Query: " << query.lastQuery();
            }

            else
            {
                if (query.next()) {
                    entry.setId(query.value("ID").toInt());
                }
            }
        }

    }

    else
    {
        query.prepare("UPDATE Buchungen "
                      "SET Wert = :wert, Konto = :konto, Gegenkonto = :gkonto, "
                      "Beleg = :beleg, Beschreibung = :beschreibung, Datum = :datum, "
                      "LastChanged = :lastchanged, Buchungskreis = :buchungskreis "
                      "WHERE ID = :id");

        query.bindValue(":id", entry.id());
        query.bindValue(":wert", entry.wert());
        query.bindValue(":konto", entry.konto());
        query.bindValue(":gkonto", entry.gkonto());
        query.bindValue(":beleg", entry.beleg());
        query.bindValue(":beschreibung", entry.description());
        query.bindValue(":datum", entry.datum());
        query.bindValue(":lastchanged", entry.lastchanged());
        query.bindValue(":buchungskreis", entry.set());

        query.exec();


        if (!query.exec()) {
            qDebug() << "Fehler 1: " << query.lastError().text();
            qDebug() << "Query: " << query.lastQuery();
        }
    }
}

void VebuDatabase::loadAccountData(QList<AccountEntry*> &accountList){

    qDeleteAll(accountList);
    accountList.clear();

    QSqlQuery query;
    QString queryStr = QString("SELECT * FROM Kontenplan;");
    query.prepare(queryStr);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    } else {
        while (query.next()) {
            AccountEntry* setNext = new AccountEntry;

            setNext->setNumber(query.value("ID").toInt());
            setNext->setdescription(query.value("Desc").toString());
            setNext->setType(query.value("Type").toString());

            accountList.append(setNext);
        }
    }
}

void VebuDatabase::loadBookingsForSet(int id, QList<BookEntry*> &bookingslist){
    qDeleteAll(bookingslist);
    bookingslist.clear();

    QSqlQuery query;
    QString queryStr = QString("SELECT * FROM Buchungen WHERE Buchungskreis = %1;").arg(id);
    query.prepare(queryStr);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    } else {
        while (query.next()) {
            BookEntry* setNext = new BookEntry;

            setNext->setId(query.value("ID").toInt());

            setNext->setWert(query.value("Wert").toInt());

            setNext->setKonto(query.value("Konto").toInt());

            setNext->setGkonto(query.value("Gegenkonto").toInt());

            setNext->setBeleg(query.value("Beleg").toString());

            setNext->setdescription(query.value("Beschreibung").toString());

            setNext->setDatum(query.value("Datum").toDate());

            setNext->setLastchanged(query.value("LastChanged").toDate());

            setNext->setSet(query.value("Buchungskreis").toInt());

            bookingslist.append(setNext);
        }
    }
}

void VebuDatabase::loadBookingsForYear(int year, QList<BookEntry*> &bookingslist){
    qDeleteAll(bookingslist);
    bookingslist.clear();

    QSqlQuery query;
    QString queryStr = QString("SELECT * FROM Buchungen WHERE Datum >= '%1-01-01' AND Datum < '%2-01-01';").arg(year).arg(year+1);
    query.prepare(queryStr);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    } else {
        while (query.next()) {
            BookEntry* setNext = new BookEntry;

            setNext->setId(query.value("ID").toInt());

            setNext->setWert(query.value("Wert").toInt());

            setNext->setKonto(query.value("Konto").toInt());

            setNext->setGkonto(query.value("Gegenkonto").toInt());

            setNext->setBeleg(query.value("Beleg").toString());

            setNext->setdescription(query.value("Beschreibung").toString());

            setNext->setDatum(query.value("Datum").toDate());

            setNext->setLastchanged(query.value("LastChanged").toDate());

            setNext->setSet(query.value("Buchungskreis").toInt());

            bookingslist.append(setNext);
        }        
    }
}

void VebuDatabase::loadSetsForYear(int year, QList<BookSet*> &setlist){
    QSqlQuery query;
    QString queryStr = QString("SELECT * FROM BKreise WHERE Jahr = %1;").arg(year);
    query.prepare(queryStr);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    } else {
        while (query.next()) {
            BookSet* setNext = new BookSet;

            setNext->setId(query.value("ID").toInt());

            setNext->setKonto(query.value("Konto").toInt());

            setNext->setMonth(query.value("Monat").toInt());

            setNext->setYear(query.value("Jahr").toInt());

            setlist.append(setNext);
        }
    }
}

void VebuDatabase::loadUserData(QStringList &name) {

    QStringList mType = {"Desc_1", "Desc_2", "Street", "Number", "Zip", "Town", "Email", "Telephone"};

    QSqlQuery query;
    QString queryStr = QString("SELECT * FROM Person WHERE ID = 1;");
    query.prepare(queryStr);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    } else {
        while (query.next()) {
            // int id = query.value("ID").toInt();

            foreach (QString nextType, mType) {
                QString querynext = query.value(nextType).toString();
                name.append(querynext);
            }
        }
    }
}

void VebuDatabase::addUserData(const QString &name, const int type) {

    QString mType = "";

    switch (type)
    {
    case 0:
        mType = "Desc_1";
        break;

    case 1:
        mType = "Desc_2";
        break;

    case 2:
        mType = "Street";
        break;

    case 3:
        mType = "Number";
        break;

    case 4:
        mType = "Zip";
        break;

    case 5:
        mType = "Town";
        break;

    case 6:
        mType = "Email";
        break;

    case 7:
        mType = "Telephone";
        break;

    default:
        break;
    }

    QSqlQuery query;
    query.prepare("INSERT OR IGNORE INTO Person (ID) VALUES (1)");

    if (!query.exec()) {
        qDebug() << "Fehler 1: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    }

    QString queryStr = QString("UPDATE Person SET %1 = :name WHERE ID = 1;").arg(mType);
    query.prepare(queryStr);
    query.bindValue(":name", name);

    if (!query.exec()) {
        qDebug() << "Fehler 2: " << query.lastError().text();
        qDebug() << "Query: " << query.lastQuery();
    }
}

void VebuDatabase::createTables(void) {

    QSqlQuery query;
    if (!query.exec(
                R"(
                CREATE TABLE IF NOT EXISTS Personen
                (ID INTEGER PRIMARY KEY,
                Desc_1 TEXT DEFAULT ' ',
                Desc_2 TEXT DEFAULT ' ',
                Street TEXT DEFAULT ' ',
                Number TEXT DEFAULT ' ',
                Zip TEXT DEFAULT ' ',
                Town TEXT DEFAULT ' ',
                Email TEXT DEFAULT ' ',
                Telephone TEXT DEFAULT ' '
                )
                )"
                ))
    {
        qDebug() << "Fehler beim Erstellen der Tabelle:" << query.lastError().text();
    }

    if (!query.exec(
                R"(
                CREATE TABLE IF NOT EXISTS Kontenplan
                (ID INTEGER PRIMARY KEY,
                Desc TEXT DEFAULT ' ',
                Type TEXT DEFAULT ' '
                )
                )"
                ))
    {
        qDebug() << "Fehler beim Erstellen der Tabelle:" << query.lastError().text();
    }

    if (!query.exec(
                R"(
                CREATE TABLE IF NOT EXISTS BKreise
                (ID INTEGER PRIMARY KEY,
                Konto INT,
                Monat INT,
                Jahr INT
                )
                )"
                ))
    {
        qDebug() << "Fehler beim Erstellen der Tabelle:" << query.lastError().text();
    }

    if (!query.exec(
                R"(
                CREATE TABLE IF NOT EXISTS Buchungen
                (ID INTEGER PRIMARY KEY,
                Wert INT,
                Konto INT,
                Gegenkonto INT,
                Beleg TEXT,
                Beschreibung TEXT,
                Datum DATE,
                LastChanged TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                Buchungskreis INT
                )
                )"
                ))
    {
        qDebug() << "Fehler beim Erstellen der Tabelle:" << query.lastError().text();
    }

    query.exec(
            R"(
                CREATE TRIGGER UpdateLastChangedTime
                    AFTER UPDATE ON Buchungen
                        FOR EACH ROW
                            BEGIN
                                UPDATE Buchungen SET LastChanged = CURRENT_TIMESTAMP WHERE ID = OLD.ID;
                END;
                )"
        );

}
