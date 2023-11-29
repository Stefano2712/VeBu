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

Item {
    id: tableview

    signal exitView(int index)

    // Damit das Item Tastatureingaben empfangen kann!!
    focus: true

    MessageDialog {
       id: helpDialog
       text: "<b>Buchen</b><br />
Verwende zum Wechseln der Felder die TAB- oder Enter-Taste. Nach dem letzten Feld wird die Buchung gespeichert.<br />
<br />"
       visible: false
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

        Row {
            spacing: 10

            Text {
                id: t_betr
                width: tableview.width / 8
                text: "Betrag"
            }

            Text {
                id: t_gkto
                width: tableview.width / 5
                text: "Gegenkto."
            }

            Text {
                id: t_bel
                width: tableview.width / 5
                text: "Beleg"
            }

            Text {
                id: t_dat
                width: tableview.width / 8
                text: "Datum"
            }

            Text {
                id: t_beschr
                width: tableview.width / 5
                text: "Beschreibung"
            }
        }

        Row {
            spacing: 10

            Keys.onPressed:(event) => {
               if (event.key === Qt.Key_Return)
               {

               }

               else if (event.key === Qt.Key_Escape)
               {
                   exitView(0)
               }
            }

            TextField {
                id: tf_wert
                width: t_betr.width
                text: "0,00"

                inputMethodHints : Qt.ImhFormattedNumbersOnly
                validator: RegularExpressionValidator{regularExpression: /^[0-9,/]+/}

                onAccepted: {
                    text = formatCurrency(text);
                    focus = false
                }

                Keys.onPressed:(event) => {
                   if (event.key === Qt.Key_Tab) {
                       text = formatCurrency(text);
                        cb_account.focus = true;
                   }

                   if (event.key === Qt.Key_Return) {
                       text = formatCurrency(text);
                       cb_account.focus = true;
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
                id: cb_account
                height: tf_wert.height
                width: t_gkto.width
                model: vebu.accountList

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

                Keys.onReturnPressed: tf_bezeichnung.focus = true

                inputMethodHints : Qt.ImhFormattedNumbersOnly
                validator: RegularExpressionValidator{regularExpression: /^[0-9,/]+/}
            }

            TextField {
                id: tf_bezeichnung

                width: t_beschr.width
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
                    width: tableview.width / 5
                    text: getCommas(modelData.wert)

                    function getCommas(wert) {
                        return (wert / 100 + "," + wert % 100);
                    }
                }

                Text {
                    width: tableview.width / 5
                    text: modelData.gkonto
                }

                Text {
                    width: tableview.width / 5
                    text: modelData.beleg
                }

                Text {
                    width: tableview.width / 5
                    text: Qt.formatDate(modelData.datum, "dd.MM.yyyy")
                }

                Text {
                    width: tableview.width / 5
                    text: modelData.description
                }
            }
        }
    }
}

