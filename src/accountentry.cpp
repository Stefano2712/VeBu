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
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

#include "accountentry.h"

AccountEntry::AccountEntry(QObject* parent)
    : QObject{parent}
    ,m_number(-1)
    ,m_description("")
    ,m_type("")
{

}

QString AccountEntry::type() const {
 return m_type;
}

void AccountEntry::setType(const QString& value) {
 if(m_type != value) {
   m_type = value;
   emit typeChanged(); // trigger signal of property change
 }
}

QString AccountEntry::description() const {
 return m_description;
}

void AccountEntry::setdescription(const QString& value) {
 if(m_description != value) {
   m_description = value;
   emit descriptionChanged(); // trigger signal of property change
 }
}

int AccountEntry::number() const {
 return m_number;
}

void AccountEntry::setNumber(const int value) {
 if(m_number != value) {
   m_number = value;
   emit numberChanged(); // trigger signal of property change
 }
}

void AccountEntry::setDefaultList(QList<AccountEntry*> &alist)
{
   QFile file(":/plans/skr49.json");

   if (!file.open(QIODevice::ReadOnly)) {
       qWarning("Kann die Datei nicht öffnen!");
           return;
   }

   QByteArray jsonData = file.readAll();
   file.close();

   QJsonDocument doc = QJsonDocument::fromJson(jsonData);
   if (doc.isNull()) {
       qWarning("Fehler beim Parsen der JSON-Daten.");
       return;
   }

   QJsonArray jsonArray = doc.array();

   for (int i = 0; i < jsonArray.size(); ++i) {
       QJsonObject obj = jsonArray[i].toObject();
       QString nummer = obj.value("nummer").toString();
       QString bezeichnung = obj.value("bezeichnung").toString();
       QString typ = obj.value("typ").toString();

       AccountEntry* nextEnt = new AccountEntry;
       nextEnt->setNumber(nummer.toInt());
       nextEnt->setdescription(bezeichnung);
       nextEnt->setType(typ);

       alist.append(nextEnt);
   }
 }
