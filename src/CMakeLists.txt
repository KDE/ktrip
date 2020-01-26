set(ktrip_SRCS
    main.cpp
    querycontroller.cpp
    locationcache.cpp
    formatter.cpp
    localizer.cpp
    resources.qrc
)

kconfig_add_kcfg_files(ktrip_SRCS ktripsettings.kcfgc GENERATE_MOC)

if (ANDROID)
    list(APPEND ktrip_SRCS androidutils.cpp)
endif()

add_executable(ktrip ${ktrip_SRCS})
target_link_libraries(ktrip PRIVATE Qt5::Qml Qt5::Gui KF5::CoreAddons KF5::I18n KF5::ConfigGui KF5::Contacts KPublicTransport)

if (ANDROID)
    target_link_libraries(ktrip PRIVATE
        KF5::Kirigami2
        KF5::ItemModels
        Qt5::Svg
        OpenSSL::SSL
        Qt5::AndroidExtras
    )

    kirigami_package_breeze_icons(ICONS
        go-down-symbolic
        go-next-symbolic
        go-up-symbolic
        view-refresh
        search
        dialog-ok
        channel-secure-symbolic
        channel-insecure-symbolic
    )
else()
    target_link_libraries(ktrip PRIVATE Qt5::Widgets)
endif()

install(FILES ktrip.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

install(TARGETS ktrip ${INSTALL_TARGETS_DEFAULT_ARGS})
install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
