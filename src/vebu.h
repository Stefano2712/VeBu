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
#ifndef VEBU_H
#define VEBU_H

#include <QObject>
#include "settings.h"
#include "bookentry.h"
#include "accountentry.h"

class VeBu: public QObject
{
    Q_OBJECT
    Q_PROPERTY(Settings* settings MEMBER m_settings CONSTANT)
    Q_PROPERTY(QList<BookEntry*> bookingList READ getbookingList NOTIFY bookingListChanged)
    Q_PROPERTY(QList<BookEntry*> bookingReport READ getBookingReport NOTIFY bookingReportChanged)
    Q_PROPERTY(QList<AccountEntry*> accountSetList READ getaccountSetList NOTIFY accountSetListChanged)
    Q_PROPERTY(QList<AccountEntry*> accountAreaList READ getaccountAreaList NOTIFY accountAreaListChanged)
    Q_PROPERTY(QList<BookEntry*> accountInitialList READ getaccountInitialList NOTIFY accountInitialListChanged)    
    Q_PROPERTY(int currentmonth READ getcurrentmonth NOTIFY currentmonthChanged)
    Q_PROPERTY(int currentyear READ getcurrentyear WRITE setcurrentyear NOTIFY currentyearChanged)
    Q_PROPERTY(int currentaccount READ getcurrentaccount NOTIFY currentaccountChanged)
    Q_PROPERTY(QString currentaccountname READ getcurrentaccountname NOTIFY currentaccountnameChanged)

signals:
    void bookingListChanged();
    void accountListChanged();
    void accountSetListChanged();
    void accountAreaListChanged();
    void accountInitialListChanged();
    void currentmonthChanged();
    void currentyearChanged();
    void currentaccountChanged();
    void currentaccountnameChanged();
    void bookingReportChanged();

public:
    explicit VeBu(QObject *parent = nullptr);
     QList<BookEntry*> getbookingList() const { return m_entries; }    
     QList<AccountEntry*> getaccountSetList() const { return m_accountSetList; }
     QList<AccountEntry*> getaccountAreaList() const { return m_accountAreaList; }
     QList<BookEntry*> getaccountInitialList() const { return m_accountInitialList; }
     int getcurrentmonth() const { return m_currentmonth; }
     int getcurrentyear() const { return m_currentyear; }
     int getcurrentaccount() const { return m_currentaccount; }
     QString getcurrentaccountname() const;
     QList<BookEntry*> getBookingReport() const { return m_reportList; }

 public slots:
     void updateBookingSet(int account, int month);
     void updateAccounts();
     void addBooking(QString wert, QString gkonto, QString beleg, QString date, QString desc);
     void addAccount(QString number, QString description, QString type);
     void deleteccount(QString number);
     void setcurrentyear(int year) {m_currentyear = year;}
     void setaccountarea(int area);
     void setbookingReport(int account);
     void modifyBooking(int id, QString wert);

     QString getSummary(int area, QString type);

private:
    Settings* m_settings;
    QList<BookEntry*> m_entries;
    QList<BookEntry*> m_yearbookings;
    QList<AccountEntry*> m_accounts;
    QList<BookEntry*> m_accountInitialList;
    QList<AccountEntry*> m_accountSetList;
    QList<AccountEntry*> m_accountAreaList;
    QList<BookEntry*> m_reportList;
    void addDefaultSet();
    BookEntry* findBookEntry(int number);
    int m_currentmonth;
    int m_currentyear;
    int m_currentaccount;
    int m_currentbookset;
};

#endif // VEBU_H
