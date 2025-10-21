import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.VectorImage

TabButton {
    id: root
    property int borderWidth: 0
    property int radius: 15
    property color activeColor: "#565a5c"
    property color inactiveColor: "#464646"
    property var iconSources: ["../../../../Downloads/train-icon-noRect.svg","../../../../Downloads/train-icon-2.svg"]

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: iconRow.width + 16

    // Added to aid during design
    contentItem: Rectangle {
        implicitWidth: iconRow.width + 16
        implicitHeight: 60
        color: "transparent"

        Row {
            id: iconRow
            spacing: 10

            anchors.centerIn: parent

            Repeater {
                model: backend.uniqueTrainColors
                // model: ["#62361b", "#522398"]
                delegate: Rectangle {
                    width: 40
                    height: 40
                    color: modelData
                    radius: 6

                    VectorImage {
                        source: "./images/train-icon-noRect.svg"
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        anchors.fill: parent
                    }
                }
            }
        }
    }


    background: Rectangle {
        id: main
        anchors.fill: parent
        color: root.checked ? root.activeColor : root.inactiveColor
        topLeftRadius: root.radius
        topRightRadius: root.radius
        border.width: root.borderWidth

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: root.borderWidth
            anchors.rightMargin: root.borderWidth
            height: root.borderWidth
            color: parent.color
        }
    }
}
