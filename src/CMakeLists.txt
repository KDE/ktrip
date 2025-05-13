# SPDX-FileCopyrightText: 2019-2021 Nicolas Fella <nicolas.fella@gmx.de>
# SPDX-License-Identifier: BSD-2-Clause

set(ktrip_SRCS
    main.cpp
    controller.cpp
    localizer.cpp
    localizer.h
    resources.qrc
)

kconfig_add_kcfg_files(ktrip_SRCS ktripsettings.kcfgc GENERATE_MOC)

add_executable(ktrip ${ktrip_SRCS})

ecm_add_qml_module(ktrip URI "org.kde.ktrip"
    QML_FILES
    qml/Main.qml
    qml/BackendPage.qml
    qml/QueryPage.qml
    qml/ConnectionsPage.qml
    qml/ConnectionDetailsPage.qml
    qml/DeparturesPage.qml
    qml/ConnectionHeading.qml
    DEPENDENCIES
    "QtCore"
    "org.kde.kpublictransport"
)

target_link_libraries(ktrip PRIVATE Qt::Qml Qt::Gui Qt::QuickControls2 KF6::CoreAddons KF6::I18n KF6::ConfigGui KPublicTransport)
target_include_directories(ktrip PRIVATE ${CMAKE_BINARY_DIR})

if (ANDROID)
    target_link_libraries(ktrip PRIVATE
        KF6::Kirigami
        Qt::Svg
        OpenSSL::SSL
    )

    kirigami_package_breeze_icons(ICONS
        go-down-symbolic
        go-up-symbolic
        channel-secure-symbolic
        channel-insecure-symbolic
        arrow-down
        emblem-ok-symbolic
        mark-location-symbolic
        system-search-symbolic
        collapse
        expand
        configure
        globe
        settings-configure
        arrow-right
        arrow-right-double
        help-about
        license
        ktrip
    )

    ecm_add_android_apk(ktrip ANDROID_DIR ${CMAKE_SOURCE_DIR}/android)
else()
    target_link_libraries(ktrip PRIVATE Qt::Widgets KF6::Crash)
endif()

ecm_add_app_icon(ktrip ICONS 256-org.kde.ktrip.png 150-org.kde.ktrip.png)

if (NOT ANDROID)
    install(FILES org.kde.ktrip.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)
    install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
endif()

install(TARGETS ktrip ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
