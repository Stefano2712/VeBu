import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Dialogs

Item {
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
        title: "Kontenblätter"
        id: helpDialog

        ColumnLayout {
            anchors.fill: parent
            TextEdit {
                textFormat: TextEdit.RichText
                text: "Hier können alle Buchungen für das laufende Jahr überprüft werden.<br /><br />"
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
        width: parent.width - 40
        height: mitem.height - 100

        VebuBackground {
            border.color: "#2196F3"
            radius: 2
            id: bkgrd

            Rectangle {
                x: bkgrd.x + 10
                y: bkgrd.y + 10
                width: jab_text.width
                height: jab_text.height
                border.color: "black"
                border.width: 2

                Text {
                    id: jab_text
                    anchors.centerIn: parent
                    padding: 10

                    text: "Kontenblatt"
                    font.bold: true;
                }
            }

            VebuComboBox {
                x: bkgrd.width - 380
                y: bkgrd.y + 5
                width: 100

                model: ["Ideell", "VerVw", "ZwBet", "WiBet", "Sammelk"]

                onCurrentIndexChanged: {
                    vebu.setaccountarea(currentIndex);
                    accList.currentIndexChanged();
                }
            }

            VebuComboBox {
                id: accList
                x: bkgrd.width - 260
                y: bkgrd.y + 5
                width: 250

                model: vebu.accountAreaList

                textRole: "description"

                onCurrentIndexChanged: {
                    if (model[currentIndex])
                        vebu.setbookingReport(model[currentIndex].number);
                }
            }

            Rectangle {
                x: bkgrd.x + 2
                y: bkgrd.y + 10 + jab_text.height + 10

                width: bkgrd.width - 4
                height: bkgrd.height - jab_text.height - jab_text.height + 14

                ListView {

                    width: bkgrd.width - 4
                    height: parent.height - 30

                    model: vebu.bookingReport

                    delegate: Rectangle {

                        id: mrect
                        width: bkgrd.width - 4
                        height: nextrow.height
                        border.color: "black"
                        border.width: 1

                        Row {
                            id: nextrow

                            Text {
                                verticalAlignment: Text.AlignVCenter
                                text: getCommas(modelData.wert)
                                width: mrect.width / 5
                                height: 30
                                leftPadding: 10

                                color: modelData.wert < 0 ? "red" : "black"

                                function getCommas(wert) {

                                    if (wert >= 0)
                                    {
                                    if ((wert % 100) < 10)
                                        return ("  " + Math.floor(wert / 100) + ",0" + wert % 100);
                                    else
                                        return ("  " + Math.floor(wert / 100) + "," + wert % 100);
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
                                verticalAlignment: Text.AlignVCenter
                                text: modelData.beleg
                                width: mrect.width / 5
                                height: 30
                            }

                            Text {
                                verticalAlignment: Text.AlignVCenter
                                text: modelData.description
                                width: mrect.width / 5
                                height: 30
                            }

                            Text {
                                verticalAlignment: Text.AlignVCenter
                                text: Qt.formatDate(modelData.datum, "dd.MM.yyyy")
                                width: mrect.width / 5
                                height: 30
                            }

                            Text {
                                verticalAlignment: Text.AlignVCenter
                                text: modelData.konto
                                width: mrect.width / 5
                                height: 30
                            }
                        }
                    }
                }
            }
        }
    }
}

