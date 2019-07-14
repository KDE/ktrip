set(ktrip_SRCS
    main.cpp
    querycontroller.cpp
    locationquerymodel.cpp
)

if (ANDROID)
    list(APPEND ktrip_SRCS androidutils.cpp)
endif()

qt5_add_resources(ktrip_SRCS resources.qrc)
add_executable(ktrip ${ktrip_SRCS})
target_link_libraries(ktrip PRIVATE Qt5::Qml Qt5::Gui KPublicTransport)

if (ANDROID)
    target_link_libraries(ktrip PRIVATE
        KF5::Kirigami2
        Qt5::Svg
        OpenSSL::SSL
        Qt5::AndroidExtras
    )

    kirigami_package_breeze_icons(ICONS
        checkmark
        clock
        dialog-cancel
        document-edit
        document-open
        document-save
        documentinfo
        edit-delete
        edit-download
        edit-paste
        go-down-symbolic
        go-home
        go-next-symbolic
        go-up-symbolic
        help-about
        map-symbolic
        meeting-attending
        question
        settings-configure
        view-calendar-day
        view-refresh
    )
else()
    target_link_libraries(ktrip Qt5::Widgets)
endif()

install(TARGETS ktrip ${INSTALL_TARGETS_DEFAULT_ARGS})

if (NOT ANDROID)
    install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
endif()
