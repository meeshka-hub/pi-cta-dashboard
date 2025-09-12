

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick

Rectangle {
    id: rectangle1
    width: Constants.width
    height: Constants.height
    color: "#565a5c"
    border.width: 2

    Text {
        id: text1
        x: 201
        y: 59
        color: "#ffffff"
        // text: qsTr("Brown Line")
        text: backend.line
        font.pixelSize: 60
        font.bold: true
    }

    Item {
        id: trainLogo
        x: 25
        y: 21

        Image {
            id: image1
            x: 0
            y: 0
            width: 151
            height: 146
            source: "../../../../Downloads/train-icon-2.svg"
            sourceSize.width: 199
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: border1
            x: 0
            y: 0
            width: 151
            height: 146
            radius: 18
            border.width: 2
            border.color: "#989898"
        }
    }

    ListView {
        id: listView
        y: 217
        height: 439
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 25
        anchors.rightMargin: 357
        spacing: 7
        layoutDirection: Qt.LeftToRight
        model: trainModel
        reuseItems: true
        delegate: Row {
            id: row1
            width: 900
            spacing: 5

            Rectangle {
                id: rectangle
                width: 900
                height: 110
                color: "#62361b"
                radius: 8
                border.color: "#989898"
                border.width: 1


                Column {
                    id: column
                    x: 77
                    y: 29
                    height: rectangle.border.width
                    spacing: 3


                    Text {
                        id: runInfo
                        color: "#ffffff"
                        text: qsTr("Run Info Here")
                        font.pixelSize: 12
                    }
                    Text {
                        id: destinationName
                        color: "#ffffff"
                        text: dest_station_name
                        font.pixelSize: 36
                    }
                }

                Text {
                    id: eta
                    x: rectangle.width - 175
                    y: 29
                    color: "#ffffff"
                    text: eta_in_mins
                    font.pixelSize: 45
                }

                Text {
                    id: littleNum
                    x: 19
                    y: 48
                    color: "#ffffff"
                    text: qsTr("num")
                    font.pixelSize: 12
                }

            }
        }
    }
}
