# SPDX-FileCopyrightText: 2019-2021 Nicolas Fella <nicolas.fella@gmx.de>
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)

# KDE Applications version, managed by release script.
set(RELEASE_SERVICE_VERSION_MAJOR "23")
set(RELEASE_SERVICE_VERSION_MINOR "11")
set(RELEASE_SERVICE_VERSION_MICRO "70")
set(RELEASE_SERVICE_VERSION "${RELEASE_SERVICE_VERSION_MAJOR}.${RELEASE_SERVICE_VERSION_MINOR}.${RELEASE_SERVICE_VERSION_MICRO}")

project(ktrip VERSION ${RELEASE_SERVICE_VERSION})

set(QT_MIN_VERSION "6.5.0")
set(KF_MIN_VERSION "5.240.0")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMAddTests)
include(ECMGenerateHeaders)
include(ECMQtDeclareLoggingCategory)
include(ECMSetupVersion)
include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEClangFormat)
include(ECMQMLModules)
include(KDEGitCommitHooks)
include(ECMCheckOutboundLicense)
include(ECMAddAppIcon)
include(ECMAddAndroidApk)

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX KTRIP
    VERSION_HEADER ${CMAKE_CURRENT_BINARY_DIR}/version.h
)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS CoreAddons I18n ItemModels Config)

if (ANDROID)
    # runtime dependencies are build-time dependencies on Android
    find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Svg)
    find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS Kirigami2)
    find_package(OpenSSL REQUIRED)

    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/android/version.gradle.in ${CMAKE_BINARY_DIR}/version.gradle)

else()
    find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Widgets)
    find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS QQC2DesktopStyle)
endif()

find_package(KPublicTransport)
set_package_properties(KPublicTransport PROPERTIES TYPE REQUIRED PURPOSE "Query online journey information")

ecm_find_qmlmodule(org.kde.kitemmodels 1.0)
ecm_find_qmlmodule(org.kde.kirigamiaddons.dateandtime 0.1)
ecm_find_qmlmodule(org.kde.kirigamiaddons.formcard 1.0)

add_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_NO_CAST_TO_ASCII -DQT_NO_URL_CAST_FROM_STRING)
add_definitions(-DQT_NO_NARROWING_CONVERSIONS_IN_CONNECT)
add_definitions(-DQT_USE_QSTRINGBUILDER)
add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x050d00)

find_package(KF${QT_MAJOR_VERSION}KirigamiAddons 0.11.0 REQUIRED)
set_package_properties(KF6KirigamiAddons PROPERTIES
    TYPE REQUIRED
    PURPOSE "Required runtime dependency (all modules are required)"
)

ki18n_install(po)

add_subdirectory(src)

install(FILES org.kde.ktrip.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

# add clang-format target for all our real source files
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)

file(GLOB_RECURSE ALL_SOURCE_FILES *.cpp *.h *.qml)
# CI installs dependency headers to _install and _build, which break the reuse check
# Fixes the test by excluding this directory
list(FILTER ALL_SOURCE_FILES EXCLUDE REGEX [[_(install|build)/.*]])
ecm_check_outbound_license(LICENSES GPL-2.0-only GPL-3.0-only FILES ${ALL_SOURCE_FILES})
