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

    MessageDialog {
        id: helpDialog
        text: "<b>Jahresabschluss</b><br />
Hier kann der Jahresabschluss für den Verein und für steuerliche Zwecke eingesehen werden. Die Trennung erfolgt nach den einzelnen Geschäftsbereichen. Eine Vermögensübersicht ist auf der letzten Seite sichtbar.<br />
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

    StackLayout {
        id: stackLayout
        anchors.top: parent.top
        anchors.centerIn: parent
        width: parent.width - 40

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: bkgrd

            height: mitem.height

            Rectangle {
                id: rext
                y: bkgrd.y + 10
                x: bkgrd.x + 10
                width: jab_text.width
                height: jab_text.height
                border.color: "black"
                border.width: 2

                Text {
                    id: jab_text
                    anchors.centerIn: parent
                    padding: 10

                    text: "Jahresabschluss " + vebu.currentyear
                    font.bold: true;
                }
            }

            VebuButton {
                y: bkgrd.y + 10
                x: bkgrd.width - 120
                width: 100

                text: "Weiter"

                onClicked: {
                    stackLayout.currentIndex = 1;
                }
            }

            Column {
                anchors.top: rext.bottom
                spacing: 10

                Text {
                    text: "Ideeller Bereich"
                    font.bold: true;
                    leftPadding: 20
                    topPadding: 20
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Einnahmen: "
                    }

                    Text {
                        text: vebu.getSummary(0, "Einnahmen")
                    }
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Ausgaben: "
                    }

                    Text {
                        text: vebu.getSummary(0, "Ausgaben")
                    }
                }

                Text {
                    text: "Vermögensverwaltung"
                    font.bold: true;
                    leftPadding: 20
                    topPadding: 10
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Einnahmen: "
                    }

                    Text {
                        text: vebu.getSummary(1, "Einnahmen")
                    }
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Ausgaben: "
                    }

                    Text {
                        text: vebu.getSummary(1, "Ausgaben")
                    }
                }

                Text {
                    text: "Zweckbetrieb"
                    font.bold: true;
                    leftPadding: 20
                    topPadding: 10
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Einnahmen: "
                    }

                    Text {
                        text: vebu.getSummary(2, "Einnahmen")
                    }
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Ausgaben: "
                    }

                    Text {
                        text: vebu.getSummary(2, "Ausgaben")
                    }
                }

                Text {
                    text: "Wirtschaftl. Geschäftsbetrieb"
                    font.bold: true;
                    leftPadding: 20
                    topPadding: 10
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Einnahmen: "
                    }

                    Text {
                        text: vebu.getSummary(3, "Einnahmen")
                    }
                }

                Row {
                    Text {
                        leftPadding: 40
                        text: "Ausgaben: "
                    }

                    Text {
                        text: vebu.getSummary(3, "Ausgaben")
                    }
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: bkgrd2

            Rectangle {
                x: bkgrd.x + 10
                y: bkgrd.y + 10
                width: kto_text.width
                height: kto_text.height
                border.color: "black"
                border.width: 2

                Text {
                    id: kto_text
                    text: "Kontennachweis zum Jahresabschluss"
                    font.bold: true;
                    anchors.centerIn: parent
                    padding: 10
                }
            }

            VebuButton {
                x: bkgrd.width - 220
                y: bkgrd.y + 10
                width: 100

                text: "Zurück"

                onClicked: {
                    stackLayout.currentIndex = 0;
                }
            }

            VebuButton {
                x: bkgrd.width - 110
                y: bkgrd.y + 10
                width: 100

                text: "Weiter"

                onClicked: {
                    stackLayout.currentIndex = 2;
                }
            }
        }

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: bkgrd3

            Rectangle {
                x: bkgrd.x + 10
                y: bkgrd.y + 10
                width: verm_text.width
                height: verm_text.height
                border.color: "black"
                border.width: 2

                Text {
                    id: verm_text

                    text: "Vermögensübersicht " + vebu.currentyear
                    font.bold: true;
                    anchors.centerIn: parent
                    padding: 10
                }
            }

            VebuButton {
                x: bkgrd.width - 220
                y: bkgrd.y + 10
                width: 100

                text: "Zurück"

                onClicked: {
                    stackLayout.currentIndex = 1;
                }
            }
        }
    }
}

