/*
    SPDX-FileCopyrightText: 2021 Volker Krause <vkrause@kde.org>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels
import org.kde.i18n.localeData
import org.kde.kpublictransport as PublicTransport
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.ktrip

Kirigami.ScrollablePage {
    id: root

    /**
     * Initially selected country.
     * If not specified the country from the current locale is used.
     */
    property string initialCountry: Qt.locale().name.match(/_([A-Z]{2})/)[1]
    required property PublicTransport.Manager publicTransportManager
    property PublicTransport.location location

    Kirigami.PromptDialog {
        id: clearConfirmDialog
        title: i18n("Clear History")
        subtitle: i18n("Do you really want to remove all previously searched locations?")
        standardButtons: QQC2.Dialog.Cancel
        customFooterActions: [
            Kirigami.Action {
                text: i18n("Remove")
                icon.name: "edit-clear-history"
                onTriggered: {
                    locationHistoryModel.clear();
                    deleteConfirmDialog.close();
                }
            }
        ]
    }

    QQC2.ActionGroup {
        id: sortActionGroup
    }
    actions: [
        Kirigami.Action {
            text: i18n("Clear history")
            icon.name: "edit-clear-history"
            onTriggered: clearConfirmDialog.open()
        },
        Kirigami.Action {
            separator: true
        },
        Kirigami.Action {
            QQC2.ActionGroup.group: sortActionGroup
            checkable: true
            checked: historySortModel.sortRoleName == "locationName"
            text: i18n("Sort by name")
            onTriggered: historySortModel.sortRoleName = "locationName"
        },
        Kirigami.Action {
            QQC2.ActionGroup.group: sortActionGroup
            checkable: true
            checked: historySortModel.sortRoleName == "lastUsed"
            text: i18n("Most recently used")
            onTriggered: historySortModel.sortRoleName = "lastUsed"
        },
        Kirigami.Action {
            QQC2.ActionGroup.group: sortActionGroup
            checkable: true
            checked: historySortModel.sortRoleName == "useCount"
            text: i18n("Most often used")
            onTriggered: historySortModel.sortRoleName = "useCount"
        }
    ]

    function updateQuery(): void {
        if (queryTextField.text !== "" && countryCombo.currentValue !== "") {
            locationQueryModel.request = {
                location: {
                    name: queryTextField.text,
                    country: countryCombo.currentValue
                },
                types: PublicTransport.Location.Stop | PublicTransport.Location.Address
            };
        }
    }

    header: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing
        CountryComboBox {
            id: countryCombo
            Layout.topMargin: Kirigami.Units.smallSpacing
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.rightMargin: Kirigami.Units.smallSpacing
            Layout.fillWidth: true
            model: {
                var countries = new Array();
                for (const b of publicTransportManager.backends) {
                    if (!publicTransportManager.isBackendEnabled(b.identifier)) {
                        continue;
                    }
                    for (const t of [PublicTransport.CoverageArea.Realtime, PublicTransport.CoverageArea.Regular, PublicTransport.CoverageArea.Any]) {
                        for (const c of b.coverageArea(t).regions) {
                            if (c != 'UN' && c != 'EU') {
                                countries.push(c.substr(0, 2));
                            }
                        }
                    }
                }
                return sort([...new Set(countries)]);
            }
            initialCountry: root.initialCountry
            onCurrentValueChanged: root.updateQuery()
        }

        Kirigami.SearchField {
            id: queryTextField
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.rightMargin: Kirigami.Units.smallSpacing
            Layout.fillWidth: true
            onAccepted: root.updateQuery()
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }
    }

    PublicTransport.LocationQueryModel {
        id: locationQueryModel
        manager: root.publicTransportManager
        queryDelay: 500
    }
    PublicTransport.LocationHistoryModel {
        id: locationHistoryModel
    }

    KSortFilterProxyModel {
        id: historySortModel
        sourceModel: locationHistoryModel
        sortRoleName: KTripSettings.historySortMode
        onSortRoleChanged: KTripSettings.historySortMode = sortRoleName
        sortOrder: sortRoleName == "locationName" ? Qt.AscendingOrder : Qt.DescendingOrder
        sortCaseSensitivity: Qt.CaseInsensitive
    }

    Component {
        id: historyDelegate
        Delegates.RoundedItemDelegate {
            id: delegate

            readonly property var sourceModel: ListView.view.model

            icon {
                name: model.location.iconName
                width: Kirigami.Units.iconSizes.medium
                height: Kirigami.Units.iconSizes.medium
            }

            text: model.location.name
            Accessible.name: {
                let country = Country.fromAlpha2(model.location.country);
                let region = CountrySubdivision.fromCode(model.location.region);

                if (model.location.locality && model.location.name !== model.location.locality && region && country) {
                    return i18nc("location name, locality, region, country", "%1, %2, %3, %4", model.location.name, model.location.locality, region.name, country.name);
                } else if (model.location.locality && model.location.name !== model.location.locality && country) {
                    return i18nc("location name, locality, country", "%1, %2, %3", model.location.name, model.location.locality, country.name);
                } else if (region && country) {
                    return i18nc("location name, region, country", "%1, %2, %3", model.location.name, region.name, country.name);
                } else {
                    return model.location.name;
                }
            }

            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing

                Delegates.SubtitleContentItem {
                    itemDelegate: delegate
                    subtitle: {
                        let country = Country.fromAlpha2(model.location.country);
                        let region = CountrySubdivision.fromCode(model.location.region);

                        if (model.location.locality && model.location.name !== model.location.locality && region && country) {
                            return i18nc("locality, region, country", "%1, %2, %3", model.location.locality, region.name, country.name);
                        } else if (model.location.locality && model.location.name !== model.location.locality && country) {
                            return i18nc("locality, country", "%1, %2", model.location.locality, country.name);
                        } else if (region && country) {
                            return i18nc("region, country", "%1, %2", region.name, country.name);
                        } else if (country) {
                            return country.name;
                        } else {
                            return " ";
                        }
                    }
                }

                QQC2.ToolButton {
                    icon.name: "edit-delete"
                    text: i18n("Remove history entry")
                    display: QQC2.ToolButton.IconOnly
                    onClicked: {
                        sourceModel.removeRows(model.index, 1);
                    }
                    enabled: model.removable
                }
            }

            onClicked: {
                root.location = model.location;
                locationHistoryModel.addLocation(model.location);
                applicationWindow().pageStack.goBack();
            }
            Accessible.onPressAction: delegate.clicked()
        }
    }

    Component {
        id: queryResultDelegate
        QQC2.ItemDelegate {
            id: delegate
            text: {
                let country = Country.fromAlpha2(model.location.country);
                let region = CountrySubdivision.fromCode(model.location.region);

                if (model.location.locality && model.location.name !== model.location.locality && region && country) {
                    return i18nc("location name, locality, region, country", "%1, %2, %3, %4", model.location.name, model.location.locality, region.name, country.name);
                } else if (model.location.locality && model.location.name !== model.location.locality && country) {
                    return i18nc("location name, locality, country", "%1, %2, %3", model.location.name, model.location.locality, country.name);
                } else if (region && country) {
                    return i18nc("location name, region, country", "%1, %2, %3", model.location.name, region.name, country.name);
                } else {
                    return model.location.name;
                }
            }

            width: ListView.view.width
            contentItem: Kirigami.IconTitleSubtitle {
                Accessible.ignored: true

                icon.name: model.location.iconName

                title: model.location.name

                subtitle: {
                    let country = Country.fromAlpha2(model.location.country);
                    let region = CountrySubdivision.fromCode(model.location.region);

                    if (model.location.locality && model.location.name !== model.location.locality && region && country) {
                        return i18nc("locality, region, country", "%1, %2, %3", model.location.locality, region.name, country.name);
                    } else if (model.location.locality && model.location.name !== model.location.locality && country) {
                        return i18nc("locality, country", "%1, %2", model.location.locality, country.name);
                    } else if (region && country) {
                        return i18nc("region, country", "%1, %2", region.name, country.name);
                    } else if (country) {
                        return country.name;
                    } else {
                        return " ";
                    }
                }
            }
            onClicked: {
                root.location = model.location;
                locationHistoryModel.addLocation(model.location);
                applicationWindow().pageStack.goBack();
                queryTextField.clear();
            }
            Accessible.onPressAction: delegate.clicked()
        }
    }

    ListView {
        id: locationView
        model: queryTextField.text === "" ? historySortModel : locationQueryModel
        delegate: queryTextField.text === "" ? historyDelegate : queryResultDelegate

        QQC2.BusyIndicator {
            anchors.centerIn: parent
            running: locationQueryModel.loading
        }

        QQC2.Label {
            anchors.centerIn: parent
            width: parent.width
            text: locationQueryModel.errorMessage
            color: Kirigami.Theme.negativeTextColor
            wrapMode: Text.Wrap
        }

        Kirigami.PlaceholderMessage {
            text: i18n("No locations found")
            visible: locationView.count === 0 && !locationQueryModel.loading && queryTextField !== ""
            anchors.centerIn: parent
        }
    }
}
