/*
 * Copyright 2020 Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.latte 0.2 as Latte

Item{
    id: root

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    Layout.fillWidth: !isHorizontal
    Layout.fillHeight: isHorizontal

    Layout.minimumWidth: -1
    Layout.minimumHeight: -1
    Layout.preferredWidth: {
        if (isInLatte) {
            return latteBridge.iconSize;
        }

        return isHorizontal ? height : 64;
    }

    Layout.preferredHeight: {
        if (isInLatte) {
            return latteBridge.iconSize;
        }

        return isHorizontal ? width : 64;
    }

    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal

    //BEGIN Latte Dock Communicator
    property QtObject latteBridge: null // current Latte v0.9 API
    //END  Latte Dock Communicator

    //BEGIN Latte based properties
    readonly property bool enforceLattePalette: latteBridge && latteBridge.applyPalette && latteBridge.palette
    readonly property bool isInLatte: latteBridge !== null
    readonly property bool latteInEditMode: latteBridge && latteBridge.inEditMode
    //END Latte based properties

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    Latte.IconItem{
        id: icon
        anchors.centerIn: parent
        source: "gtk-index"
        width: latteBridge.iconSize
        height: width

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var command = 'qdbus org.kde.lattedock /Latte toggleHiddenState "' + plasmoid.configuration.latteLayout + '" "' + Screen.name + '" ' + plasmoid.configuration.screenEdge;
                console.log("Executing command : " + command);
                executable.exec(command);
            }
        }
    }

}
