# SPDX-FileCopyrightText: 2019-2021 Nicolas Fella <nicolas.fella@gmx.de>
# SPDX-License-Identifier: BSD-2-Clause

set(ktrip_SRCS
    main.cpp
    controller.cpp
    locationcachemodel.cpp
    formatter.cpp
    resources.qrc
)

kconfig_add_kcfg_files(ktrip_SRCS ktripsettings.kcfgc GENERATE_MOC)

if (ANDROID)
    list(APPEND ktrip_SRCS androidutils.cpp)
endif()

add_executable(ktrip ${ktrip_SRCS})
target_link_libraries(ktrip PRIVATE Qt::Qml Qt::Gui Qt::QuickControls2 KF${QT_MAJOR_VERSION}::CoreAddons KF${QT_MAJOR_VERSION}::I18n KF${QT_MAJOR_VERSION}::ConfigGui KPublicTransport)
target_include_directories(ktrip PRIVATE ${CMAKE_BINARY_DIR})

if (ANDROID)
    target_link_libraries(ktrip PRIVATE
        KF${QT_MAJOR_VERSION}::Kirigami2
        KF${QT_MAJOR_VERSION}::ItemModels
        Qt::Svg
        OpenSSL::SSL
        Qt::AndroidExtras
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
        arrow-right-double
        help-about
    )
else()
    target_link_libraries(ktrip PRIVATE Qt::Widgets)
endif()

ecm_add_app_icon(ktrip ICONS 256-org.kde.ktrip.png 150-org.kde.ktrip.png)

install(FILES org.kde.ktrip.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

install(TARGETS ktrip ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
