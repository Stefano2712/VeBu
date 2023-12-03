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

Item {
    height: parent.height
    id: myitem

    x: parent.width / 2 - fillrect.width / 2
    y: parent.height / 2 - fillrect.height / 2 - 20

    signal bookingSelectionClick(int i)

    signal exitView(int index)

    focus: true

    Keys.onPressed:(event) => {
       if (event.key === Qt.Key_Escape)
       {
           exitView(0)
       }
    }

    VebuBackground {
        width: col1.width + 50
        height: col1.height + 50
        id: fillrect

        Column {
            id: col1
            anchors.centerIn: parent

            spacing: 10

            signal buttonClick(int menuId)

            Text {
                text: "Was soll gebucht werden?"
            }

            VebuComboBox {
                id: kreisbox
                model: vebu.accountSetList
                textRole: "description"
            }

            VebuComboBox {
                id: monthbox
                model: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
            }

            VebuButton {
                width: kreisbox.width
                text: "Öffnen"
                menuId: 1
            }

            VebuButton {
                width: kreisbox.width
                text: "Zurück"
                menuId: 0
            }

            onButtonClick: (menuId) => {
                vebu.updateBookingSet(kreisbox.model[kreisbox.currentIndex].number, monthbox.currentIndex + 1);
                myitem.bookingSelectionClick(menuId);
            }
        }
    }
}
