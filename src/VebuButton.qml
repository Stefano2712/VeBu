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
import QtQuick.Controls.Imagine

Button {
    id: vebuButton
    text: "Button"
    width: 150
    height: 40

    property int menuId: 0

    onClicked: {
        if (typeof parent.buttonClick === "function")
        {
            parent.buttonClick(vebuButton.menuId)
        }
    }

    contentItem: Text {
        text: parent.text
        color: "black"  // Setzt die Textfarbe auf Rot
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    background: Rectangle {
        color: vebuButton.down ? "#2196F3" : "#b4e4e9"
        border.color: vebuButton.down ? "blue" : "grey"
        border.width: 2
        radius: 4
    }
}
