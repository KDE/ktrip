/**
 * SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.coreaddons as KCoreAddons
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kpublictransport 1.0 as KPT

Row {
    id: root
    property KPT.journey journey

    spacing: Kirigami.Units.smallSpacing

    Kirigami.Heading {
        id: durationHeading
        level: 2
        text: KCoreAddons.Format.formatDuration(root.journey.duration * 1000, KCoreAddons.FormatTypes.HideSeconds)
        font.strikeout: root.journey.disruptionEffect == KPT.Disruption.NoService
    }

    Repeater {
        model: root.journey.sections

        delegate: Loader {
            sourceComponent: model.modelData.route.line.hasLogo ? secIcon : secLabel

            Component {
                id: secIcon
                Kirigami.Icon {
                    width: height
                    height: durationHeading.height
                    source: modelData.route.line.logo
                }
            }

            Component {
                id: secLabel
                Label {
                    height: durationHeading.height
                    text: modelData.route.line.name
                }
            }
        }
    }
}
