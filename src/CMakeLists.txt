add_subdirectory(dateandtime)

set(ktrip_SRCS
    main.cpp
    querycontroller.cpp
    locationcache.cpp
    formatter.cpp
    resources.qrc
)

if (ANDROID)
    list(APPEND ktrip_SRCS androidutils.cpp)
endif()

add_executable(ktrip ${ktrip_SRCS})
target_link_libraries(ktrip PRIVATE Qt5::Qml Qt5::Gui KF5::I18n KPublicTransport)

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
    )
else()
    target_link_libraries(ktrip PRIVATE Qt5::Widgets)
endif()

install(TARGETS ktrip ${INSTALL_TARGETS_DEFAULT_ARGS})

if (NOT ANDROID)
    install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
endif()
