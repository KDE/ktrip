/*
    SPDX-FileCopyrightText: 2019 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as QQC2
import org.kde.i18n.localeData 1.0
import org.kde.kirigami 2.10 as Kirigami
import org.kde.kirigamiaddons.delegates 1.0 as Delegates
import org.kde.kpublictransport 1.0 as KPublicTransport
import org.kde.ktrip

Kirigami.ScrollablePage {
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

    KPublicTransport.BackendModel {
        id: backendModel
        manager: Controller.manager
    }

    Component {
        id: backendDelegate

        Delegates.RoundedItemDelegate {
            enabled: model.itemEnabled

            contentItem: Item {
                anchors.margins: Kirigami.Units.largeSpacing
                implicitHeight: childrenRect.height

                QQC2.Label {
                    id: nameLabel
                    text: model.name
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.right: securityIcon.left
                    anchors.rightMargin: Kirigami.Units.largeSpacing
                    // try to retain trailing abbreviations when we have to elide
                    elide: text.endsWith(")") ? Text.ElideMiddle : Text.ElideRight
                }
                Kirigami.Icon {
                    id: securityIcon
                    source: model.isSecure ? "channel-secure-symbolic" : "channel-insecure-symbolic"
                    color: model.isSecure ? Kirigami.Theme.positiveTextColor : Kirigami.Theme.negativeTextColor
                    width: height
                    height: Kirigami.Units.gridUnit
                    anchors.top: parent.top
                    anchors.right: toggle.left
                }
                QQC2.Switch {
                    id: toggle
                    checked: model.backendEnabled
                    onToggled: model.backendEnabled = checked
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
                QQC2.Label {
                    anchors.top: nameLabel.bottom
                    anchors.left: parent.left
                    anchors.right: toggle.left
                    anchors.topMargin: Kirigami.Units.smallSpacing
                    text: model.description
                    font.italic: true
                    wrapMode: Text.WordWrap
                }
            }

            onClicked: {
                toggle.toggle(); // does not trigger the signal handler for toggled...
                model.backendEnabled = toggle.checked;
            }
        }
    }

    ListView {
        model: backendModel
        delegate: backendDelegate

        section {
            property: "countryCode"
            delegate: Kirigami.ListSectionHeader {
                width: ListView.view.width
                text: {
                    switch (section) {
                    case "":
                    case "UN":
                        return i18n("Global");
                    case "EU":
                        return i18n("🇪🇺 European Union");
                    default:
                        const c = Country.fromAlpha2(section);
                        return i18nc("emoji flag, country name", "%1 %2", c.emojiFlag, c.name);
                    }
                }
            }
            criteria: ViewSection.FullString
        }
    }
}
