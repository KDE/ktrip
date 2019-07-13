cmake_minimum_required(VERSION 3.0)

find_package(ECM 5.38 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_SOURCE_DIR}/cmake)

include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
include(ECMAddTests)
include(ECMGenerateHeaders)
include(ECMQtDeclareLoggingCategory)
include(ECMSetupVersion)
include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)

find_package(Qt5 REQUIRED COMPONENTS Gui Qml Widgets)

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)
endif()

find_package(KPublicTransport REQUIRED)

set(CMAKE_AUTOMOC ON)

add_subdirectory(src)
