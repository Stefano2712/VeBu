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
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts 2.15

Item {
    id: tableview

    signal exitView(int index)

    focus: true

    Keys.onPressed:(event) => {
       if (event.key === Qt.Key_Escape)
       {
           exitView(0)
       }
    }

    Dialog {
        anchors.centerIn: parent
        width: 300
        modal: true
        visible: false
        title: "Buchen"
        id: helpDialog

        ColumnLayout {
            anchors.fill: parent
            TextEdit {
                textFormat: TextEdit.RichText
                text: "Verwende zum Wechseln der Felder die TAB- oder Enter-Taste. Nach dem letzten Feld wird die Buchung gespeichert.<br /><br />"
                readOnly: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            VebuButton {
                text: "OK"
                Layout.preferredHeight: 30
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    // Aktion bei Klick auf Bestätigen
                    helpDialog.visible = false
                }
            }

            Keys.onPressed: {
                event => {
                    helpDialog.visible = false
                }
            }
        }
    }

    Component.onCompleted: {
       HelpSignal.helpRequested.connect(showHelp)
    }

    Component.onDestruction: {
       HelpSignal.helpRequested.disconnect(showHelp)
    }

    function showHelp() {
       helpDialog.open()
    }

    Column {
        spacing: 10
        width: parent.width
        height: parent.height
        leftPadding: 10

        Row {
            Text {
                font.bold: true;
                text: "Buchungskreis: " + vebu.currentaccountname
            }

            Text {
                font.bold: true;
                text: "  -  "
            }

            Text {
                font.bold: true;
                text: "Monat: " + monthstr(vebu.currentmonth)

                function monthstr(month) {
                    if (month < 10)
                        return "0" + month;

                    return month;
                }
            }
        }

        Row {
            spacing: 10

            Text {
                id: t_betr
                width: tableview.width / 10
                text: "Betrag"
            }

            Text {
                id: t_bereich
                width: tableview.width / 10
                text: "Bereich"
            }

            Text {
                id: t_gkto
                width: tableview.width / 4
                text: "Gegenkto."
            }

            Text {
                id: t_bel
                width: tableview.width / 5
                text: "Beleg"
            }

            Text {
                id: t_dat
                width: tableview.width / 10
                text: "Datum"
            }

            Text {
                id: t_beschr                
                width: tableview.width / 4
                text: "Beschreibung"
            }
        }

        Row {
            spacing: 10            

            TextField {
                id: tf_wert
                width: t_betr.width
                text: "0,00"

                inputMethodHints : Qt.ImhFormattedNumbersOnly
                validator: RegularExpressionValidator{regularExpression: /^-?\d+(\,\d{1,2})?$/}

                Keys.onPressed:(event) => {
                   if (event.key === Qt.Key_Tab) {
                       text = formatCurrency(text);
                        cb_bereich.focus = true;
                   }

                   if (event.key === Qt.Key_Return) {
                       text = formatCurrency(text);
                       cb_bereich.focus = true;
                   }
                }

                function formatCurrency(text) {
                    var parts = text.split(',');

                    if (parts.length === 1) {
                        return text + ',00';
                    } else if (parts.length === 2) {
                        return parts[0] + ',' + parts[1].padEnd(2, '0');
                    } else {
                        return text;
                    }
                }
            }

            VebuComboBox {
                id: cb_bereich
                y: tf_wert.y - 5
                height: tf_wert.height + 10
                width: t_bereich.width
                model: ["Ideell", "VerVw", "ZwBet", "WiBet", "Sammelk"]

                onCurrentIndexChanged: {
                    vebu.setaccountarea(currentIndex);
                    cb_account.focus = true;
                }

                Keys.onPressed:(event) => {
                   if (event.key === Qt.Key_Tab) {
                        vebu.setaccountarea(currentIndex);
                        cb_account.focus = true;
                   }

                   if (event.key === Qt.Key_Return) {
                        vebu.setaccountarea(currentIndex);
                       cb_account.focus = true;
                   }
                }
            }

            VebuComboBox {
                id: cb_account
                y: tf_wert.y - 5
                height: tf_wert.height + 10
                width: t_gkto.width
                model: vebu.accountAreaList

                textRole: "description"

                Keys.onReturnPressed: tf_beelg.focus = true
            }

            TextField {
                id: tf_beelg
                width: t_bel.width
                text: ""

                Keys.onReturnPressed: tf_datum.focus = true
            }

            TextField {
                id: tf_datum
                width: t_dat.width
                text: "01"

                inputMethodHints : Qt.ImhFormattedNumbersOnly
                validator: RegularExpressionValidator{regularExpression: /^[0-9]+/}

                Keys.onPressed:(event) => {
                   if (event.key === Qt.Key_Tab) {
                       text = checkMonth(text);
                        tf_bezeichnung.focus = true;
                   }

                   if (event.key === Qt.Key_Return) {
                       text = checkMonth(text);
                       tf_bezeichnung.focus = true;
                   }
                }

                function checkMonth(month) {

                    switch (vebu.currentmonth)
                    {
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 12:
                        if (month > 31) month = 31;
                        break;

                    case 2:
                        // TODO: Add Schaltjahr!
                        if (month > 28) month = 28;
                        break;

                    case 4:
                    case 6:
                    case 9:
                    case 11:
                        if (month > 30) month = 30;
                        break;


                    default:
                        break;
                    }

                    return month;
                }
            }

            TextField {
                id: tf_bezeichnung

                width: t_beschr.width - 70
                text: ""

                Keys.onReturnPressed: {
                    vebu.addBooking(tf_wert.text, cb_account.model[cb_account.currentIndex].number, tf_beelg.text, tf_datum.text, tf_bezeichnung.text);
                    tf_wert.focus = true;
                }
            }
        }

        ListView {
            width: parent.width
            height: parent.height

            model: vebu.bookingList

            delegate: Row {
                spacing: 10

                Text {
                    width: t_betr.width
                    text: getCommas(modelData.wert)
                    leftPadding: 20

                    function getCommas(wert) {

                        if (wert >= 0)
                        {
                        if ((wert % 100) < 10)
                            return (Math.floor(wert / 100) + ",0" + wert % 100);
                        else
                            return (Math.floor(wert / 100) + "," + wert % 100);
                        }

                        else
                        {
                            if ((-wert % 100) < 10)
                                if (wert > -100) return ("-0,0" + (-wert % 100));
                                else return (Math.ceil(wert / 100) + ",0" + (-wert % 100));

                            else
                                if (wert > -100) return ("-0," + (-wert % 100));
                                else return (Math.ceil(wert / 100) + "," + (-wert % 100));
                        }
                    }
                }

                Text {
                    width: t_bereich.width
                    text: ""
                    leftPadding: 20
                }

                Text {
                    width: t_gkto.width
                    text: modelData.gkonto
                    leftPadding: 20
                }

                Text {
                    width: t_bel.width
                    text: modelData.beleg
                    leftPadding: 20
                }

                Text {
                    width: t_dat.width
                    text: Qt.formatDate(modelData.datum, "dd.MM.yyyy")
                    leftPadding: 10
                }

                Text {
                    width: t_beschr.width
                    text: modelData.description
                    leftPadding: 20
                }
            }
        }
    }
}

