/*
    SPDX-FileCopyrightText: 2019 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kpublictransport.ui as KPublicTransport
import org.kde.ktrip

KPublicTransport.BackendPage {
    id: root

    title: i18n("Providers")

    header: Kirigami.InlineMessage {
        text: i18n("Select the providers relevant for your area")
        position: Kirigami.InlineMessage.Header
        visible: true
    }

    actions: [
        Kirigami.Action {
            text: i18n("Save")
            icon.name: "emblem-ok-symbolic"
            onTriggered: pageStack.pop()
        }
    ]

    publicTransportManager: Controller.manager
}
