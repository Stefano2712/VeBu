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
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs
import "."

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    title: "VeBu - Vereinsbuchhaltung"
    id: window
    color: "white"    

    MenuBar {
        id: mymenu
        width: parent.width

        Menu {
            title: "Datei"

            MenuItem {
                text: "Hauptmenü"
                onTriggered: {
                    handleBookingButtonClicked(0);
                }
            }

            MenuItem {
                text: "Einstellungen"
                onTriggered: {
                    handleButtonClicked(3);
                }
            }

            MenuItem {
                text: "Beenden"
                onTriggered: {
                    Qt.quit()
                }
            }
        }

        Menu {
            title: "Bearbeiten"

            MenuItem {
                text: "Buchen"
                onTriggered: {
                    handleButtonClicked(0);
                }
            }

            MenuItem {
                text: "Kontoeröffnung"
                onTriggered: {
                    handleButtonClicked(4);
                }
            }
        }

        Menu {
            title: "Ansicht"

            MenuItem {
                text: "Kontenblätter"
                onTriggered: {
                    handleButtonClicked(1);
                }
            }

            MenuItem {
                text: "Jahresabschluss"
                onTriggered: {
                    handleButtonClicked(2);
                }
            }
        }

        Menu {
            title: "Hilfe"

            MenuItem {
                text: "Kapitelhilfe"
                onTriggered: {
                    HelpSignal.helpRequested();
                }
            }

            MenuItem {
                text: "Über VeBu"
                onTriggered: {
                    handleButtonClicked(6);
                }
            }
        }
    }

    Row {
        y: mymenu.height

        Loader {
            id: contentLoader
            source: "MainScreenView.qml"
            width: window.width;
            height: window.height;

            onLoaded: {
                if (contentLoader.item && typeof contentLoader.item.vebuButtonClick === "function") {
                    contentLoader.item.vebuButtonClick.connect(function(receivedMenuId) {
                        handleButtonClicked(receivedMenuId);
                    });
                }

                if (contentLoader.item && typeof contentLoader.item.bookingSelectionClick === "function") {
                    contentLoader.item.bookingSelectionClick.connect(function(receivedMenuId) {
                        handleBookingButtonClicked(receivedMenuId);
                    });
                }

                if (contentLoader.item && typeof contentLoader.item.exitView === "function") {
                    contentLoader.item.exitView.connect(function(receivedMenuId) {
                        handleBookingButtonClicked(receivedMenuId);
                    });
                }
            }
        }
    }


    function handleButtonClicked(receivedMenuId) {

        switch (receivedMenuId) {
        case 0:
            contentLoader.source = "BookingSelection.qml"
            break;

        case 1:
            console.log("TODO: Implement kontenansicht screen!");
            break;

        case 2:
            console.log("TODO: Implement jahresabschluss screen!");
            break;

        case 3:
            contentLoader.source = "SettingsView.qml"
            break;

        case 4:
            contentLoader.source = "AccountList.qml"
            break;

        case 6:
        {
           licenseDialog.visible = true;
        }
        break;

        default:
            break;
        }
    }

    function handleBookingButtonClicked(receivedMenuId) {
        switch (receivedMenuId) {
        case 0:
            contentLoader.source = "MainScreenView.qml"
            break;

        case 1:
            contentLoader.source = "BookingView.qml"
            break;

        default:
            break;
        }
    }


    MessageDialog {
        id: licenseDialog
        buttons: MessageDialog.Ok
        informativeText: "This program is free software: you can redistribute it and/or modify \
it under the terms of the GNU General Public License as published by the Free \
Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY \
WARRANTY; See the GNU General Public License for more details. You should have \
received a copy of the GNU General Public License along with this program. If not, \
see https://www.gnu.org/licenses/.
                                                    "
        text:   "VeBu - Die Vereinsbuchhaltung<br />
                 Copyright (C) 2023  S. Hornstein"
        visible: false
    }
}


