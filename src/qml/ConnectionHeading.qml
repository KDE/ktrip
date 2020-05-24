/**
 * Copyright 2020 Nicolas Fella <nicolas.fella@gmx.de>
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
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kpublictransport 1.0 as KPT
import org.kde.ktrip 1.0

Row {
    id: root
    property var journey

    spacing: Kirigami.Units.smallSpacing

    Kirigami.Heading {
        id: durationHeading
        level: 2
        text: Formatter.formatDuration(root.journey.duration)
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
