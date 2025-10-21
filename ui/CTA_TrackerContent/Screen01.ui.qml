

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../CTA_Tracker'

Rectangle {
    id: canvas1
    width: Constants.width
    height: Constants.height - Constants.statusBarHeight
    color: "#565a5c"
    border.color: "#565a5c"
    border.width: 2

    Text {
        id: title
        y: 65
        color: "#ffffff"
        text: "Next trains at Diversey"
        anchors.left: trainIcon.right
        anchors.leftMargin: 25
        // text: qsTr("Brown Line")
        font.pixelSize: 60
        font.bold: true
    }

    Rectangle {
        id: trainIcon
        width: 136
        color: "#989898"
        radius: 16
        border.width: 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: trainContainer.top
        anchors.leftMargin: 25
        anchors.topMargin: 25
        anchors.bottomMargin: 25
        border.color: "#989898"

        Image {
            id: image1
            y: 25
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            source: "./images/train-icon-2.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            scale: 1
            mipmap: true
            sourceSize.width: 199
            fillMode: Image.PreserveAspectFit
        }
    }

    RowLayout {
        id: trainContainer
        height: 461
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        anchors.bottomMargin: 25
        spacing: 7

        ListView {
            id: trainList
            Layout.fillHeight: true
            Layout.fillWidth: true
            snapMode: ListView.SnapToItem
            spacing: 7
            layoutDirection: Qt.LeftToRight
            clip: true
            model: trainModel

            reuseItems: true
            delegate: Row {
                id: row1
                width: parent.width
                spacing: 5

                Rectangle {
                    id: rectangle
                    width: parent.width
                    height: 110
                    color: color_code
                    radius: 8
                    border.color: "#989898"
                    border.width: 1

                    Column {
                        id: column
                        x: 57
                        y: 19
                        spacing: -10

                        Text {
                            id: runInfo
                            color: "#ffffff"
                            text: qsTr(`Brown Line ${rn ? "#" + rn : "train"} to`)
                            font.pixelSize: 15
                        }
                        Text {
                            id: destinationName
                            color: "#ffffff"
                            text: dest_station_name
                            font.pixelSize: 55
                            verticalAlignment: Text.AlignBottom
                            font.weight: Font.DemiBold
                            font.bold: false
                        }
                    }

                    Text {
                        id: eta
                        y: 29
                        color: "#ffffff"
                        text: is_app == 1 ? "Due" : `${eta_in_mins.split(':')[1]*1} min`
                        anchors.right: parent.right
                        anchors.rightMargin: 30
                        font.pixelSize: 45
                        topPadding: 0
                        font.weight: Font.Medium
                    }

                    Text {
                        id: littleNum
                        x: 19
                        y: 48
                        color: "#ffffff"
                        text: index + 1
                        font.pixelSize: 12
                    }
                }
            }
        }

        Rectangle {
            id: trainStatus
            Layout.fillHeight: true
            Layout.preferredWidth: 320
            color: "#ffffff"
        }
    }
}
