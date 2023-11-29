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

    Keys.onPressed: {
        event => {
            exitView(0)
        }
    }

    Connections {
        target: vebu.settings

        function onUserDataChanged(data) {
            for (var i = 0; i < data.length; ++i) {
                mlistmodel.get(i).name = data[i];
            }
        }
    }

    MessageDialog {
       id: helpDialog
       text: "Hier ist Hilfe für diesen Screen."
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

    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        height: parent.height - 100
        width: parent.width - 200

        // Die TabBar wird verwendet, um zwischen den Tabs zu wechseln
        TabBar {
            id: tabBar
            anchors.top: parent.top
            width: parent.width / 2

            spacing: 10  // Abstand zwischen den TabButtons

            background: Rectangle {
                color: "transparent"
                radius: 5
            }

            TabButton {
                text: "Persönliche Daten"

                background: Rectangle {
                    color: parent.checked ? "#b4e4e9" : "lightgrey"
                    radius: 5
                }
            }

            TabButton {
                text: "Bearbeiter"

                background: Rectangle {
                    color: parent.checked ? "#b4e4e9" : "lightgrey"
                    radius: 5
                }
            }
        }

        // Der StackLayout wird verwendet, um zwischen den Seiten zu wechseln
        StackLayout {
            id: stackLayout
            anchors.top: tabBar.bottom
            anchors.left: tabBar.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            currentIndex: tabBar.currentIndex

            // Persönliche Daten Seite
            VebuBackground {
                border.color: "#2196F3"
                radius: 2

                ListView {
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.leftMargin: 10

                    id: persdaten

                    spacing: 8

                    model: ListModel {
                        id: mlistmodel
                        ListElement { desc: "Bezeichnung 1"; name: "Stefan" }
                        ListElement { desc: "Bezeichnung 2"; name: "HOrnstrein" }
                        ListElement { desc: "Straße"; name: "Im Hart" }
                        ListElement { desc: "Hausnummer"; name: "8" }
                        ListElement { desc: "Postleitzahl"; name: "" }
                        ListElement { desc: "Ort"; name: "" }
                        ListElement { desc: "Email"; name: "" }
                        ListElement { desc: "Telefon"; name: "" }
                    }

                    delegate: TextField {

                        anchors.horizontalCenter: parent.horizontalCenter 
                        width: parent.width * 3 / 4
                        height: 30

                        placeholderText: mlistmodel.get(index).desc
                        text: mlistmodel.get(index).name

                        onEditingFinished: {
                            mlistmodel.get(index).name = text
                        }
                    }

                    Component.onCompleted: {
                        vebu.settings.getUserData();
                    }
                }

                // Bearbeiter Button-Gruppe
                Row {
                    anchors { bottom: persdaten.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 10}
                    VebuButton {
                        text: "Speichern"
                        onClicked: {
                            for (var i = 0; i < mlistmodel.count; i++) {

                                //TODO: Use enum instead of integer value for declaring type of entry
                                vebu.settings.updateUserData(mlistmodel.get(i).name, i)
                            }
                        }
                    }
                }
            }

            // Bearbeiter Seite
            VebuBackground {
                id: beaarbdaten

                border.color: "#2196F3"
                radius: 2

                ListView {
                    id: listView
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10

                    spacing: 5
                    // Definiere eine Eigenschaft namens "selectedIndex"
                    property int selectedIndex: 5
                    currentIndex: selectedIndex // setze den aktuellen Index auf den Wert von selectedIndex

                    model: ListModel {
                        // Beispiel Daten
                        ListElement { name: "Bearbeiter1" }
                        ListElement { name: "Bearbeiter2" }
                    }

                    onCurrentIndexChanged: {
                        // Wenn sich der aktuelle Index ändert, aktualisiere das Modell, um die Farben zurückzusetzen
                        model.clear();
                        model.append({name: "Bearbeiter1"});
                        model.append({name: "Bearbeiter2"});
                    }

                    delegate: Rectangle {
                        width: listView.width
                        height: 50  // oder eine andere gewünschte Höhe
                        radius: 2
                        // Wenn der Index dem aktuellen Index entspricht, setze die Farbe auf Blau, ansonsten Zebrastreifen-Farbgebung
                        color: index === listView.selectedIndex ? "#2196F3" : "white"
                        border.color: index === listView.selectedIndex ? "#2196F3" : "black"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 10
                            text: model.name
                        }

                        // Mausinteraktionsbereich
                        MouseArea {
                            anchors.fill: parent
                            // Wenn auf das Rechteck geklickt wird
                            onClicked: {
                                if (listView.selectedIndex !== index) {
                                    listView.selectedIndex = index;
                                } else {
                                    listView.selectedIndex = -1;
                                }
                            }
                        }
                    }
                }

                // Bearbeiter Button-Gruppe
                Row {
                    anchors { bottom: beaarbdaten.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 10 }
                    spacing: 20
                    VebuButton {
                        text: "Hinzufügen"
                        onClicked: {
                            if (listView.selectedIndex > -1)
                            {
                                var nameAtIndex = listView.model.get(listView.selectedIndex).name;
                                console.log(nameAtIndex);
                            }
                        }
                    }

                    VebuButton {
                        text: "Bearbeiten"
                        onClicked: {
                            // Hier wird der markierte Eintrag bearbeitet
                        }
                    }

                    /*VebuButton {
                        text: "Entfernen"
                        onClicked: {
                            // Hier wird der markierte Eintrag entfernt
                            if (listView.currentIndex !== -1) {
                                listView.model.remove(listView.currentIndex)
                            }
                        }
                    }*/
                }
            }
        }
    }
}
