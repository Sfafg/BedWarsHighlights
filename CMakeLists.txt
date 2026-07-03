cmake_minimum_required(VERSION 3.30.1)
project(Highlights)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(QT_QML_GENERATE_QMLLS_INI ON)
set(CMAKE_AUTOMOC ON)

set(TESTS_ROOT "${PROJECT_SOURCE_DIR}/tests")
set(SRC_ROOT "${PROJECT_SOURCE_DIR}/src")

file(GLOB_RECURSE SRC "${SRC_ROOT}/*.cpp")
file(GLOB_RECURSE HEADER "${SRC_ROOT}/*.h")

find_package(Qt6 REQUIRED COMPONENTS Core Quick Widgets Multimedia MultimediaWidgets)
find_package(ZLIB REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(FFMPEG REQUIRED
    libavformat
    libavutil
)

qt_standard_project_setup()
qt_add_executable(Highlights ${SRC} ${HEADER} ${TESTS_ROOT}/Source.cpp ${RESOURCES})
qt_add_qml_module(Highlights
    URI ui
    QML_FILES 
        ui/Fnt.qml
        ui/Theme.qml
        ui/Context.qml
        ui/Utils.qml
        ui/Source.qml
        ui/TimeLine.qml
        ui/SeekBar.qml
        ui/EventTick.qml
        ui/PlayerControls.qml
        ui/ToolTip.qml
        ui/FilterItem.qml
        ui/Evnt.qml
        ui/EventList.qml
        ui/EventItem.qml
        ui/qmldir
    RESOURCES
        ui/icons/FaBed.svg
        ui/icons/GiDeathSkull.svg
        ui/icons/MdStart.svg
        ui/icons/TbBedOff.svg
        ui/icons/FaSmileWink.svg
        ui/icons/GiOverkill.svg
        ui/icons/RiEmotionSadFill.svg
)



add_custom_command(TARGET Highlights
    PRE_BUILD
    COMMAND pkill
    ARGS Highlights & echo 0
)

target_link_libraries(Highlights PRIVATE
    ZLIB::ZLIB
    Qt6::Core
    Qt6::Quick
    Qt6::Widgets
    Qt6::Multimedia
    Qt6::MultimediaWidgets
    ${FFMPEG_LIBRARIES}
)

target_include_directories(Highlights PRIVATE ${SRC_ROOT} ${FFMPEG_INCLUDE_DIRS})
