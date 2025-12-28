// SPDX-FileCopyrightText: 2025 Tobias Fella <tobias.fella@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

Kirigami.Page {
    id: root

    padding: 0

    MapView {
        anchors.fill: parent
    }
}
