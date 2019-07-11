qt5_add_resources(ktrip_SRCS resources.qrc)
add_executable(ktrip main.cpp querycontroller.cpp locationquerymodel.cpp ${ktrip_SRCS})
target_link_libraries(ktrip Qt5::Qml Qt5::Gui Qt5::Widgets KPublicTransport)

