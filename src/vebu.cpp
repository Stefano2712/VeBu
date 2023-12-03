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
#include "vebu.h"
#include "database.h"

VeBu::VeBu(QObject *parent)
    : QObject(parent),
    m_settings(new Settings(this))
{
    VebuDatabase* db = VebuDatabase::getInstance();
    db->createTables();
}

QString VeBu::getSummary(int area, QString type)
{
    QString result = "0";
    int m_res = 0;

    setaccountarea(area);

    switch (area)
    {
    case 0:
        // Ideeller Bereich
        foreach (BookEntry* acc, m_yearbookings) {
            if (acc->gkonto() >= 2000 && acc->gkonto() < 4000)
            {
                foreach (AccountEntry* aca, m_accountAreaList)
                {
                    if (aca->number() == acc->gkonto())
                    {
                        if (!aca->type().compare(type))
                        {
                            m_res += acc->wert();
                        }

                        break;
                    }
                }
            }
        }
        break;

    case 1:
        // Vermögensverw.
        foreach (BookEntry* acc, m_yearbookings) {
            if (acc->gkonto() >= 4000 && acc->gkonto() < 5000)
            {
                foreach (AccountEntry* aca, m_accountAreaList)
                {
                    if (aca->number() == acc->gkonto())
                    {
                        if (!aca->type().compare(type))
                        {
                            m_res += acc->wert();
                        }

                        break;
                    }
                }
            }
        }
        break;

    case 2:
        // Zweckbetrieb
        foreach (BookEntry* acc, m_yearbookings) {
            if (acc->gkonto() >= 5000 && acc->gkonto() < 7000)
            {
                foreach (AccountEntry* aca, m_accountAreaList)
                {
                    if (aca->number() == acc->gkonto())
                    {
                        if (!aca->type().compare(type))
                        {
                            m_res += acc->wert();
                        }

                        break;
                    }
                }
            }        }
        break;

    case 3:
        // Wirt. Geschbetrieb
        foreach (BookEntry* acc, m_yearbookings) {
            if (acc->gkonto() >= 8000 && acc->gkonto() < 9000)
            {
                foreach (AccountEntry* aca, m_accountAreaList)
                {
                    if (aca->number() == acc->gkonto())
                    {
                        if (!aca->type().compare(type))
                        {
                            m_res += acc->wert();
                        }

                        break;
                    }
                }
            }        }
        break;

    case 4:
        // Sammelkonten
        foreach (BookEntry* acc, m_yearbookings) {
            if (acc->gkonto() >= 100000)
            {
                foreach (AccountEntry* aca, m_accountAreaList)
                {
                    if (aca->number() == acc->gkonto())
                    {
                        if (!aca->type().compare(type))
                        {
                            m_res += acc->wert();
                        }

                        break;
                    }
                }
            }        }
        break;

    default:
        break;
    }


    if (m_res > 0)
    {
        result = QString::number(m_res / 100) + "," + QString::number(m_res % 100);
    }

    else if (m_res < 0)
    {
        result = "-" + QString::number(-m_res / 100) + "," + QString::number((-m_res) % 100);
    }

    return result;
}

void VeBu::setbookingReport(int account) {

    m_reportList.clear();

    foreach (BookEntry* aca, m_yearbookings)
    {
        if (aca->gkonto() == account)
        {
            m_reportList.append(aca);
        }
    }

    emit bookingReportChanged();
}

QString VeBu::getcurrentaccountname() const {
    foreach (AccountEntry* aca, m_accountSetList)
    {
        if (aca->number() == m_currentaccount)
        {
            return aca->description();
        }
    }

    return "";
}

void VeBu::modifyBooking(int id, QString wert) {
    VebuDatabase* db = VebuDatabase::getInstance();
    BookEntry* mentry = Q_NULLPTR;

    foreach (BookEntry* ent, m_yearbookings) {
        if (ent->id() == id) {
            mentry = ent;

            QStringList wertparse = wert.split(',');

            if (wertparse.size() == 2)
                mentry->setWert(wertparse[0].toInt() * 100 + wertparse[1].toInt());
        }
    }

    if (mentry != Q_NULLPTR) {
        db->addBooking(*mentry);
        emit bookingListChanged();
    }
}

void VeBu::addAccount(QString number, QString description, QString type)
{
    foreach (AccountEntry* acc, m_accounts)
    {
        if (acc->number() == number.toInt())
        {
            return;
        }
    }

    VebuDatabase* db = VebuDatabase::getInstance();
    AccountEntry* acc = new AccountEntry;
    acc->setNumber(number.toInt());
    acc->setdescription(description);
    acc->setType(type);

    db->addAccount(*acc);

    m_accounts.append(acc);
    m_accountAreaList.append(acc);

    emit accountAreaListChanged();
}

void VeBu::deleteccount(QString number)
{
    AccountEntry* acc = Q_NULLPTR;

    foreach (AccountEntry* entr, m_accounts)
    {
        if (entr->number() == number.toInt())
        {
            acc = entr;
            break;
        }
    }

    if (acc != Q_NULLPTR)
    {
        VebuDatabase* db = VebuDatabase::getInstance();

        if (db->deleteAccount(*acc))
        {
            m_accounts.removeAll(acc);
            m_accountAreaList.removeAll(acc);

            delete acc;
            emit accountAreaListChanged();
        }
    }
}

void VeBu::addBooking(QString wert, QString gkonto, QString beleg, QString date, QString desc) {
    VebuDatabase* db = VebuDatabase::getInstance();
    BookEntry* mentry = new BookEntry;

    QStringList wertparse = wert.split(',');

    if (wertparse.size() == 2)
    {
        if (wert.startsWith('-'))
        {
            if (wertparse[0].toInt())
                mentry->setWert(wertparse[0].toInt() * 100 - wertparse[1].toInt());
            else
                mentry->setWert(-1 * wertparse[1].toInt());
        }

        else
        {
            mentry->setWert(wertparse[0].toInt() * 100 + wertparse[1].toInt());
        }        
    }

    mentry->setKonto(m_currentaccount);
    mentry->setGkonto(gkonto.toInt());
    mentry->setdescription(desc);
    mentry->setBeleg(beleg);
    mentry->setDatum(QDate(m_currentyear, m_currentmonth, date.toInt()));
    mentry->setSet(m_currentbookset);

    db->addBooking(*mentry);

    m_entries.append(mentry);
    m_yearbookings.append(mentry);

    emit bookingListChanged();
}

void VeBu::updateAccounts(void)
{
    VebuDatabase* db = VebuDatabase::getInstance();

    QList<AccountEntry *> initList;
    db->loadAccountData(initList);
    m_accountInitialList.clear();

    db->loadBookingsForYear(m_currentyear, m_yearbookings);

    if (initList.isEmpty())
    {
        AccountEntry::setDefaultList(initList);

        foreach (AccountEntry* acc, initList) {
            db->addAccount(*acc);
        }
    }

    m_accounts.clear();
    m_accountSetList.clear();

    foreach (AccountEntry* acc, initList) {
        if (!acc->type().compare("UV"))
        {
            m_accountSetList.append(acc);

            BookEntry* mentry = findBookEntry(acc->number());

            if (mentry == 0)
            {
                mentry = new BookEntry;
                mentry->setWert(0);
                mentry->setKonto(acc->number());
                mentry->setGkonto(9000);
                mentry->setdescription(acc->description());
                mentry->setDatum(QDate(m_currentyear,1,1));
                db->addBooking(*mentry);
            }

            m_accountInitialList.append(mentry);
        }

        else
        {
            m_accounts.append(acc);
        }
    }

    emit accountListChanged();
    emit accountSetListChanged();
    emit accountInitialListChanged();
}

void VeBu::setaccountarea(int setid)
{
    m_accountAreaList.clear();

    switch (setid)
    {
    case 0:
        // Ideeller Bereich

        foreach (AccountEntry* acc, m_accounts) {
            if (acc->number() >= 2000 && acc->number() < 4000)
            {
                m_accountAreaList.append(acc);
            }
        }
        break;

    case 1:
        // Vermögensverw.

        foreach (AccountEntry* acc, m_accounts) {
            if (acc->number() >= 4000 && acc->number() < 5000)
                m_accountAreaList.append(acc);
        }
        break;

    case 2:
        // Zweckbetrieb

        foreach (AccountEntry* acc, m_accounts) {
            if (acc->number() >= 5000 && acc->number() < 7000)
                m_accountAreaList.append(acc);
        }
        break;

    case 3:
        // Wirt. Geschbetrieb

        foreach (AccountEntry* acc, m_accounts) {
            if (acc->number() >= 8000 && acc->number() < 9000)
                m_accountAreaList.append(acc);
        }
        break;

    case 4:
        // Sammelkonten
        foreach (AccountEntry* acc, m_accounts) {
            if (acc->number() >= 100000)
                m_accountAreaList.append(acc);
        }
        break;

    default:
        break;
    }

    emit accountAreaListChanged();
}

BookEntry* VeBu::findBookEntry(int account)
{
    foreach (BookEntry* acc, m_yearbookings) {
        if (acc->gkonto() == 9000
            && acc->konto() == account)
            return acc;
    }

    return 0;
}

void VeBu::updateBookingSet(int account, int month)
{
    VebuDatabase* db = VebuDatabase::getInstance();
    BookSet m_set;
    m_set.setKonto(account);
    m_set.setMonth(month);
    m_set.setYear(m_currentyear);

    db->addSet(m_set);
    db->loadBookingsForSet(m_set.id(), m_entries);

    emit bookingListChanged();

    m_currentbookset = m_set.id();
    m_currentaccount = account;
    m_currentmonth = month;

    emit currentmonthChanged();
    emit currentyearChanged();
    emit currentaccountChanged();
}
