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
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs

Item {
    height: parent.height
    id: myitem

    signal vebuButtonClick(int i) // used in VebuButton!

    x: parent.width / 2 - fillrect.width / 2
    y: parent.height / 2 - fillrect.height / 2 - 20

    Dialog {
        anchors.centerIn: parent
        width: 300
        modal: true
        visible: false
        title: "Willkommen!"
        id: helpDialog

        ColumnLayout {
            anchors.fill: parent
            TextEdit {
                textFormat: TextEdit.RichText
                text: "Willkommen bei VeBu, der Buchhaltungssoftware für kleine Vereine.<br />
<br />
Prüfe zu Beginn die Stände der Bestandskonten unter Einstellungen->Kontoeröffnung. Danach kannst Du mit dem Buchen beginnen. Viel Spaß!"
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

    VebuBackground {
        width: col1.width + col2.width + 50
        height: col2.height + 50
        id: fillrect

        Row {
            anchors.centerIn: parent

            Column {
                id: col1

                Rectangle {
                    width: 280
                    height: col2.height
                    color: "transparent"

                    Image {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/images/vebu_1_1.png"
                        width: 250
                        height: 250
                    }

                    // Logo mit Text "VeBu"
                    /*Rectangle {
                        width: 100
                        height: 100
                        color: "blue"
                        border.color: "white"
                        border.width: 2
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "VeBu"
                            color: "white"
                            font.pixelSize: 24
                            font.bold: true
                        }
                    }*/
                }
            }

            Column {
                id: col2
                spacing: 10

                signal buttonClick(int menuId) // used in VebuButton!

                VebuComboBox {
                    id: yearComboBox
                    model: [2020, 2021, 2022, 2023]

                    property bool completed: false

                    onCurrentIndexChanged:  {
                        if (completed)
                        {
                            vebu.currentyear = model[currentIndex];
                            vebu.updateAccounts();
                        }
                    }

                    Component.onCompleted: {
                            completed = true;
                            setCurrentIndexToCurrentYear();
                            vebu.currentyear = model[currentIndex];
                            vebu.updateAccounts();
                    }

                    function setCurrentIndexToCurrentYear() {
                        for (var i = 0; i < yearComboBox.model.length; i++) {
                            if (yearComboBox.model[i] === vebu.currentyear) {
                                yearComboBox.currentIndex = i;
                                break;
                            }
                        }
                    }
                }

                VebuButton {
                    text: "Buchen"
                    menuId: 0
                }

                VebuButton {
                    text: "Kontenblätter"
                    menuId: 1
                }

                VebuButton {
                    text: "Jahresabschluss"
                    menuId: 2
                }

                VebuButton {
                    text: "Einstellung"
                    menuId: 3

                }

                onButtonClick: (menuId) =>
                    myitem.vebuButtonClick(menuId)
            }
        }
    }
}


