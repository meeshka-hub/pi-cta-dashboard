import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../CTA_Tracker'

Window {
    id: window
    width: Constants.width
    height: Constants.height

    visible: true

    SwipeView {
        id: swipeView
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        currentIndex: tabBar.currentIndex

        Screen01 {}
        Screen02 {}
    }

    Rectangle {
        id: header
        x: 0
        y: 0
        width: window.width
        height: Constants.statusBarHeight
        color: "#000000"

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            layoutDirection: Qt.LeftToRight
            spacing: 0
            uniformCellSizes: true

            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 20

                text: "Transit Dashboard - CTA"
                font.bold: false
                font.weight: Font.DemiBold
                font.pointSize: 20
                color: "#949494"
            }


            TabBar {
                id: tabBar
                spacing: 0

                focusPolicy: Qt.TabFocus
                Layout.fillWidth: true
                Layout.fillHeight: true

                CustomButtonTab {
                    text: "Screen 1"
                }
                CustomButtonTab {
                    text: "Screen 2"
                }
                CustomButtonTab {
                    text: "Screen 3"
                }
            }


            Text {
                id: clockDisplay
                color: "#ffffff"
                text: Qt.formatTime(new Date())
                font.pixelSize: 30
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.rightMargin: 10
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.weight: Font.Bold
                Timer {
                    id: timeUpdate
                    running: true
                    repeat: true
                    onTriggered: { clockDisplay.text = Qt.formatTime(new Date()) }
                }
            }

        }
    }

    Connections {
        target: window
        function onActiveChanged() { console.log("clicked") }
    }
}
