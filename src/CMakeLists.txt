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
target_link_libraries(ktrip PRIVATE Qt::Qml Qt::Gui Qt::QuickControls2 KF5::CoreAddons KF5::I18n KF5::ConfigGui KPublicTransport)
target_include_directories(ktrip PRIVATE ${CMAKE_BINARY_DIR})

if (ANDROID)
    target_link_libraries(ktrip PRIVATE
        KF5::Kirigami2
        KF5::ItemModels
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
    )
else()
    target_link_libraries(ktrip PRIVATE Qt::Widgets)
endif()

install(FILES org.kde.ktrip.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

install(TARGETS ktrip ${INSTALL_TARGETS_DEFAULT_ARGS})
install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
