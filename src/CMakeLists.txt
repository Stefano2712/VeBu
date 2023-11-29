cmake_minimum_required(VERSION 3.16)

project(VeBu VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/vebu.rc")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(VeBu
    main.cpp
    ${app_icon_resource_windows}
)

qt_add_resources(VeBu "app_images"
    PREFIX "/"
    FILES
        images/vebu_1_1.png
        icons/vebu_16_16.ico
        plans/skr49.json
)

qt_add_qml_module(VeBu
    URI VeBu
    VERSION 1.0
    QML_FILES Main.qml BookList.qml BookingView.qml MainScreenView.qml
    SOURCES bookentry.h bookentry.cpp vebu.h vebu.cpp
    QML_FILES VebuButton.qml
    QML_FILES BookingSelection.qml
    QML_FILES VebuComboBox.qml
    QML_FILES VebuBackground.qml
    QML_FILES SettingsView.qml
    SOURCES settings.h settings.cpp
    SOURCES database.cpp
    SOURCES database.h
    SOURCES accountentry.h accountentry.cpp
    SOURCES bookset.h bookset.cpp
    QML_FILES AccountList.qml HelpSignal.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(VeBu PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.VeBu
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(VeBu
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
    # PRIVATE:
    # Bedeutet, dass die verknüpften Bibliotheken und Include-Verzeichnisse nur für das aktuelle Target relevant sind.
    # Andere Targets, die von diesem Target abhängen, erben diese nicht.
)

include(GNUInstallDirs)
install(TARGETS VeBu
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
