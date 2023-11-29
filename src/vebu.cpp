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

    updateAccounts();
}

/**
 * For testing.
 */
void VeBu::addDefaultSet(void) {

}

void VeBu::addBooking(QString wert, QString gkonto, QString beleg, QString date, QString desc) {
    VebuDatabase* db = VebuDatabase::getInstance();
    BookEntry* mentry = new BookEntry;

    QStringList wertparse = wert.split(',');

    if (wertparse.size() == 2)
        mentry->setWert(wertparse[0].toInt() * 100 + wertparse[1].toInt());

    mentry->setKonto(m_currentaccount);
    mentry->setGkonto(gkonto.toInt());
    mentry->setdescription(desc);
    mentry->setBeleg(beleg);
    mentry->setDatum(QDate(m_currentyear, m_currentmonth, date.toInt()));
    mentry->setSet(m_currentset);

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
    db->loadBookingsForYear(2022, m_yearbookings);

    if (m_accounts.isEmpty())
    {
        AccountEntry::setDefaultList(initList);

        foreach (AccountEntry* acc, initList) {
            db->addAccount(*acc);
        }
    }

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
               mentry->setDatum(QDate(2022,1,1));
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

    m_currentset = m_set.id();
    m_currentaccount = account;
    m_currentmonth = month;

    emit currentmonthChanged();
    emit currentyearChanged();
    emit currentaccountChanged();
}
