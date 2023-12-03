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
        title: "Kontenplan"
        id: helpDialog

        ColumnLayout {
            anchors.fill: parent
            TextEdit {
                textFormat: TextEdit.RichText
                text: "Hier können Konten neu angelegt oder auch gelöscht werden. Das Löschen funktioniert nur, wenn ein Konto noch nicht gebucht wird. Halte Dich beim Anlegen der Konten an den Kontenrahmen SKR49.<br /><br />"
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
                id: plantext
                text: "Kontenplan"
                font.bold: true;
                leftPadding: 10
                topPadding: 10
            }

            VebuComboBox {
                id: cb_area
                width: bkgrd.width - 40
                anchors.top: plantext.bottom
                anchors.left: plantext.left
                anchors.leftMargin: 20
                model: ["Ideell", "Vermögensverw.", "Zweckbetrieb", "Wirts. Gesch.", "Sammelkonto"]

                onCurrentIndexChanged: {
                    vebu.setaccountarea(currentIndex);
                }

                Keys.onPressed:(event) => {
                   if (event.key === Qt.Key_Tab) {
                        vebu.setaccountarea(currentIndex);
                   }

                   if (event.key === Qt.Key_Return) {
                        vebu.setaccountarea(currentIndex);
                   }
                }
            }

            ListView {
                anchors.top: cb_area.bottom
                height: bkgrd.height - 200
                width: bkgrd.width - 20
                id: listing
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 8

                model: vebu.accountAreaList

                property int selectedIndex: -1
                currentIndex: selectedIndex

                delegate: Rectangle {
                    width: listing.width
                    height: 20
                    radius: 2

                    // Wenn der Index dem aktuellen Index entspricht, setze die Farbe auf Blau
                    color: index === listing.selectedIndex ? "#2196F3" : "white"
                    border.color: index === listing.selectedIndex ? "#2196F3" : "black"

                    Row {
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: " ";
                        }

                        Text {
                            text: modelData.number;
                            width: 100
                        }

                        Text {
                            text: modelData.description;
                            width: 100
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        // Wenn auf das Rechteck geklickt wird
                        onClicked: {
                            if (listing.selectedIndex !== index) {
                                listing.selectedIndex = index;
                            } else {
                                listing.selectedIndex = -1;
                            }
                        }
                    }
                }
            }

            Row {
                anchors {
                    topMargin: 50
                    top: listing.bottom; horizontalCenter: parent.horizontalCenter;}

                spacing: 20

                VebuButton {
                    width: 100

                    text: "Hinzufügen"
                    id: addButton
                    onClicked: {
                        stackLayout.currentIndex = 1;
                    }
                }

                VebuButton {
                    width: 100

                    text: "Bearbeiten"
                    id: deleteButton

                    onClicked: {
                        if (listing.selectedIndex != -1 && cb_area.currentIndex !== 4)
                        {
                            stackLayout.currentIndex = 2;

                            deleteNumber.text = listing.model[listing.selectedIndex].number;
                            deleteDesc.text = listing.model[listing.selectedIndex].description;
                        }

                        else if (listing.selectedIndex != -1 && cb_area.currentIndex === 4)
                        {
                            stackLayout.currentIndex = 3;

                            stackeditnumber.text = listing.model[listing.selectedIndex].number;
                            stackeditnumberdesc.text = listing.model[listing.selectedIndex].description;
                        }
                    }
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: addnewbkgrd
            height: mitem.height - 200            

            Column {
                anchors.fill: parent
                anchors.topMargin: 20
                width: addnewbkgrd.width

                spacing: 20

                Text {
                    font.bold: true
                    leftPadding: 20

                    text: "Konto hinzufügen"
                }

                Row {
                    spacing: 30

                    Text {
                        text: " "
                    }

                    TextField {
                        id: accountnumber

                        width: 70

                        text: "1234"
                    }

                    TextField {
                        id: accounttext

                        width: addnewbkgrd.width - 150

                        text: "Neues Konto"
                    }
                }

                VebuComboBox {
                    id: accounttype
                    x: accounttext.x
                    width: accounttext.width
                    model: ["Einnahmen", "Ausgaben", "AV"]
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 20

                    VebuButton {
                        width: 100

                        text: "Speichern"
                        onClicked: {
                            // SAVE DATA!!
                            vebu.addAccount(accountnumber.text, accounttext.text, accounttype.currentText);
                            stackLayout.currentIndex = 0;
                        }
                    }

                    VebuButton {
                        width: 100

                        text: "Abbruch"
                        onClicked: {
                            stackLayout.currentIndex = 0;
                        }
                    }
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: deletebkgrd
            height: mitem.height - 200

            Column {
                anchors.fill: parent
                anchors.topMargin: 20
                width: addnewbkgrd.width

                spacing: 20

                Text {
                    font.bold: true
                    leftPadding: 20

                    text: "Konto löschen"
                }

                Row {
                    spacing: 30

                    Text {
                        text: " "
                    }

                    Text {
                        id: deleteNumber
                        width: 70

                        text: "1234"
                    }

                    Text {
                        id: deleteDesc
                        width: addnewbkgrd.width - 150

                        text: "Neues Konto"
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 20

                    VebuButton {
                        width: 100

                        text: "Löschen"
                        onClicked: {
                            vebu.deleteccount(deleteNumber.text);
                            stackLayout.currentIndex = 0;
                        }
                    }

                    VebuButton {
                        width: 100

                        text: "Abbruch"
                        onClicked: {
                            stackLayout.currentIndex = 0;
                        }
                    }
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: editbkgrd
            height: mitem.height - 200

            Column {
                anchors.fill: parent
                anchors.topMargin: 20
                width: addnewbkgrd.width

                spacing: 20

                Text {
                    font.bold: true
                    leftPadding: 20

                    text: "Sammelkonto"
                }

                Row {
                    spacing: 30

                    Text {
                        text: " "
                    }

                    Text {
                        id: stackeditnumber
                        width: 70

                        text: "1234"
                    }

                    Text {
                        id: stackeditnumberdesc
                        width: addnewbkgrd.width - 150

                        text: "Neues Konto"
                    }
                }

                Row {
                    spacing: 30

                    leftPadding: 20

                    Text {
                        width: zwecktext.width
                        id: ideltext
                        text: "Ideell"
                    }

                    Text {
                        width: zwecktext.width
                        id: vermtext
                        text: "Verm.verw."
                    }

                    Text {
                        id: zwecktext
                        text: "Zweckbetr."
                    }

                    Text {
                        width: zwecktext.width
                        id: wirttext
                        text: "Wirt.Betr."
                    }
                }

                Row {
                    spacing: 30

                    leftPadding: 20

                    TextField {
                        width: ideltext.width
                        text: "25"
                    }

                    TextField {
                        width: vermtext.width
                        text: "25"
                    }

                    TextField {
                        width: zwecktext.width
                        text: "25"
                    }

                    TextField {
                        width: wirttext.width
                        text: "25"
                    }
                }

                Row {
                    spacing: 30

                    leftPadding: 20

                    TextField {
                        width: ideltext.width
                        text: "Konto 1"
                    }

                    TextField {
                        width: vermtext.width
                        text: "Konto 2"
                    }

                    TextField {
                        width: zwecktext.width
                        text: "Konto 3"
                    }

                    TextField {
                        width: wirttext.width
                        text: "Konto 4"
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 20

                    VebuButton {
                        width: 100

                        text: "Speichern"
                        onClicked: {
                            // Save Sammelkonto DATA!!

                            stackLayout.currentIndex = 0;
                        }
                    }

                    VebuButton {
                        width: 100

                        text: "Abbruch"
                        onClicked: {
                            stackLayout.currentIndex = 0;
                        }
                    }
                }
            }
        }
    }
}

