qt5_add_resources(ktrip_SRCS resources.qrc)
add_executable(ktrip main.cpp querycontroller.cpp locationquerymodel.cpp ${ktrip_SRCS})
target_link_libraries(ktrip Qt5::Qml Qt5::Gui KPublicTransport)

install(TARGETS ktrip ${INSTALL_TARGETS_DEFAULT_ARGS})

if (NOT ANDROID)
    install(PROGRAMS org.kde.ktrip.desktop DESTINATION ${KDE_INSTALL_APPDIR})
endif()
