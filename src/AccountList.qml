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
import QtQuick.Layouts 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Dialogs

Item {
    height: parent.height
    width: parent.width
    id: mitem

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
        title: "Kontoeröffnung"
        id: helpDialog

        ColumnLayout {
            anchors.fill: parent
            TextEdit {
                textFormat: TextEdit.RichText
                text: "Setze hier die Anfangsbestände der Eröffnungskonten.<br /><br />Achtung! Wenn die Daten in den Vorjahren gesetzt wurde, sollten die Bestände hier nicht mehr geändert werden, um den Zusammenhang der Vermögensübersicht zu gewährleisten.<br /><br />"
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

    StackLayout {
        id: stackLayout
        anchors.top: parent.top
        anchors.centerIn: parent
        width: parent.width / 2
        height: mitem.height - 100

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: bkgrd

            Text {
                id: saldentext
                text: "Salden zum 01.01.2022"
                font.bold: true;
                leftPadding: 10
                topPadding: 10
            }

            ListView {
                anchors.top: saldentext.bottom
                height: 200
                width: bkgrd.width - 20
                id: listing
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 8

                model: vebu.accountInitialList

                delegate: Row {                    

                    spacing: 10
                    Text {
                        text: modelData.description;
                        width: 100
                    }

                    TextField {
                        width: 100
                        inputMethodHints : Qt.ImhFormattedNumbersOnly
                        validator: RegularExpressionValidator{regularExpression: /^[0-9,/]+/}
                        text: modelData.wert

                        Keys.onPressed:(event) => {
                           if (event.key === Qt.Key_Tab) {
                               text = formatCurrency(text);
                               focus = false
                               vebu.modifyBooking(modelData.id, text)
                           }

                           if (event.key === Qt.Key_Return) {
                               text = formatCurrency(text);
                               focus = false
                               vebu.modifyBooking(modelData.id, text)
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
                }
            }

            Row {
                anchors {
                    topMargin: 50
                    top: listing.bottom; horizontalCenter: parent.horizontalCenter;}

                VebuButton {
                    text: "Hinzufügen"
                    id: addButton
                    onClicked: {
                        stackLayout.currentIndex = 1;
                        accounttext.text = "Neues Konto"
                    }
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: addnewbkgrd
            height: mitem.height - 200

            function accountExists(accountnummer) {
                for (var i = 0; i < mlistmodel.count; i++) {
                    if (mlistmodel.get(i).account === accountnummer) {
                        return true;
                    }
                }
                return false;
            }

            function getNextaccountNummer(startaccountnummer) {
                var accountnummer = startaccountnummer;
                while (accountExists(accountnummer.toString())) {
                    accountnummer++;
                }
                return accountnummer;
            }

            Column {
                anchors.fill: parent
                anchors.topMargin: 20
                width: addnewbkgrd.width

                spacing: 20

                TextField {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: accounttext

                    FontMetrics {
                            id: fontMetrics
                        }

                    property int padding: 20

                    width: fontMetrics.advanceWidth(accounttext.text) + padding

                    text: "Neues Konto"
                }

                Text {
                    text: ""
                    height: 100
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: auswahltext
                    text: "Kasse oder Bank?"
                }


                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    VebuButton {
                        width: 100
                        text: "Kasse"
                        onClicked: {
                            var neueaccountnummer = addnewbkgrd.getNextaccountNummer(1000);
                            mlistmodel.append({name: accounttext.text, wert: "0,00", account: neueaccountnummer.toString()})
                            stackLayout.currentIndex = 0;
                        }
                    }

                    VebuButton {
                        width: 100
                        text: "Bank"
                        onClicked: {
                            var neueaccountnummer = addnewbkgrd.getNextaccountNummer(1200);
                            mlistmodel.append({name: accounttext.text, wert: "0,00", account: neueaccountnummer.toString()})
                            stackLayout.currentIndex = 0;
                        }
                    }
                }

                VebuButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Abbruch"
                    onClicked: {
                        stackLayout.currentIndex = 0;
                    }
                }
            }
        }
    }
}

