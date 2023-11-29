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

ComboBox {
    id: mainscreencombo
    width: 150
    height: 50

    background: Rectangle {
        color: "white"
        border.color: mainscreencombo.activeFocus ? "blue" : "gray"
        border.width: 2
        radius: 4
    }
}
