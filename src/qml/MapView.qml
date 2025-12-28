/*
    SPDX-FileCopyrightText: 2019-2023 Volker Krause <vkrause@kde.org>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtPositioning
import QtLocation as QtLocation

import QtQuick.Controls as Controls

/** QtLocation map view with standard interaction settings. */
QtLocation.Map {
    id: root

    plugin: osmPlugin()

    // "singleton" OSM QtLocation plugin
    // we only want one of these, and created only when absolutely necessary
    // as this triggers network operations on creation already
    function osmPlugin(): QtLocation.Plugin {
        if (!__qtLocationOSMPlugin) {
            __qtLocationOSMPlugin = __qtLocationOSMPluginComponent.createObject();
        }
        return __qtLocationOSMPlugin;
    }
    property QtLocation.Plugin __qtLocationOSMPlugin: null

    Component {
        id: __qtLocationOSMPluginComponent
        QtLocation.Plugin {
            name: "maplibre"
            QtLocation.PluginParameter { name: "maplibre.map.styles"; value: "https://tiles.openfreemap.org/styles/liberty" }
        }
    }

    Controls.Label {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 2

        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignRight

        width: parent.width

        text: i18n('<a href="https://openfreemap.org" target="_blank">OpenFreeMap</a> <a href="https://www.openmaptiles.org/" target="_blank">© OpenMapTiles</a><br>Data from <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>')
    }

    property geoCoordinate startCentroid
    PinchHandler {
        id: pinch
        target: null
        onActiveChanged: if (active) {
            root.startCentroid = root.toCoordinate(pinch.centroid.position, false)
        }
        onScaleChanged: (delta) => {
            root.zoomLevel += Math.log2(delta)
            root.alignCoordinateToPoint(root.startCentroid, pinch.centroid.position)
        }
        xAxis.enabled: false
        yAxis.enabled: false
        minimumRotation: 0.0
        maximumRotation: 0.0
    }
    WheelHandler {
        id: wheel
        rotationScale: 1/120
        orientation: Qt.Vertical
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
            root.startCentroid = root.toCoordinate(wheel.point.position, false)
            root.zoomLevel += event.angleDelta.y * rotationScale
            root.alignCoordinateToPoint(root.startCentroid, wheel.point.position)
        }
    }
    DragHandler {
        id: drag
        target: null
        onTranslationChanged: (delta) => root.pan(-delta.x, -delta.y)
    }
    Shortcut {
        enabled: root.zoomLevel < root.maximumZoomLevel
        sequence: StandardKey.ZoomIn
        onActivated: root.zoomLevel = Math.round(root.zoomLevel + 1)
    }
    Shortcut {
        enabled: root.zoomLevel > root.minimumZoomLevel
        sequence: StandardKey.ZoomOut
        onActivated: root.zoomLevel = Math.round(root.zoomLevel - 1)
    }
}
