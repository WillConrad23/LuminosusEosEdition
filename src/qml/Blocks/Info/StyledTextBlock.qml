import QtQuick 2.5
import CustomElements 1.0
import QtQuick.Dialogs 1.2
import "../../CustomBasics"
import "../../CustomControls"

BlockBase {
    id: root
    width: Math.max(textInput.implicitWidth + 20*dp, 120*dp)
    height: controller.anchorManager().presentationMode
              ? 0*dp
              : 30*dp
    onWidthChanged: block.positionChanged()
    settingsComponent: settings

    // hide background in presentation mode:
    color: controller.anchorManager().presentationMode ? "transparent" : "#444"
    showShadows: !controller.anchorManager().presentationMode


    Item {
        width: Math.max(textInput.implicitWidth + 20*dp, 120*dp)
        height: Math.max(textInput.implicitHeight, 30*dp)
        anchors.bottom: parent.top

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.1)
            visible: !controller.anchorManager().presentationMode
        }

        TextEdit {
            id: textInput
            anchors.fill: parent
            anchors.margins: 4*dp

            color: block.color
            font.family: block.fontFamily
            font.pixelSize: block.fontSize * dp
            font.bold: block.bold
            font.underline: block.underline
            horizontalAlignment: block.centered ? Text.AlignHCenter : Text.AlignLeft
            textFormat: TextEdit.AutoText

            selectByMouse: true

            text: block.text
            onTextChanged: {
                if (text !== block.text) {
                    block.text = text
                }
            }
            opacity: activeFocus ? 1 : 0
            enabled: !controller.anchorManager().presentationMode
        }
        Text {
            anchors.fill: parent
            anchors.margins: 4*dp

            color: block.color
            font.family: block.fontFamily
            font.pixelSize: block.fontSize * dp
            font.bold: block.bold
            font.underline: block.underline
            horizontalAlignment: block.centered ? Text.AlignHCenter : Text.AlignLeft
            textFormat: Text.AutoText
            style: block.shadow ? Text.Raised : Text.Normal
            styleColor: block.shadowColor

            text: block.text

            opacity: (1 - textInput.opacity)
        }

        // --------------------- Position Help Lines ---------------

        Rectangle {  // left
            height: 2000*dp
            y: -1000*dp
            width: 1*dp
            x: 0*dp
            color: Qt.rgba(0.3, 0.6, 1, 1)
            visible: root.pressed
        }
        Rectangle {  // right
            height: 2000*dp
            y: -1000*dp
            width: 1*dp
            anchors.right: parent.right
            color: Qt.rgba(0.3, 0.6, 1, 1)
            visible: root.pressed
        }
        Rectangle {  // center
            height: 2000*dp
            y: -1000*dp
            width: 1*dp
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(0.3, 0.6, 1, 0.5)
            visible: root.pressed && block.centered
        }
        Rectangle {  // top
            width: 2000*dp
            x: -1000*dp
            height: 1*dp
            y: 0*dp
            color: Qt.rgba(0.3, 0.6, 1, 1)
            visible: root.pressed
        }
        Rectangle {  // bottom
            width: 2000*dp
            x: -1000*dp
            height: 1*dp
            anchors.bottom: parent.bottom
            color: Qt.rgba(0.3, 0.6, 1, 1)
            visible: root.pressed
        }

    }  // end item

    StretchColumn {
        anchors.fill: parent

        DragArea {
            text: "Styled Text"
            visible: !controller.anchorManager().presentationMode
        }
    }  // end main Column


    Component {
        id: settings
        StretchColumn {
            leftMargin: 15*dp
            rightMargin: 15*dp
            defaultSize: 30*dp

            BlockRow {
                StretchText {
                    text: "Font Size:"
                }
                NumericInput {
                    width: 60*dp
                    implicitWidth: 0  // do not stretch
                    minimumValue: 6
                    maximumValue: 200
                    value: block.fontSize
                    onValueChanged: {
                        if (value !== block.fontSize) {
                            block.fontSize = value
                        }
                    }
                }
            }

            BlockRow {
                Text {
                    text: "Font Family:"
                    width: parent.width / 2
                }
                TextInput {
                    text: block.getFontFamily()
                    width: parent.width / 2
                    inputMethodHints: Qt.ImhPreferLatin
                    onDisplayTextChanged: {
                        block.setFontFamily(displayText)
                    }
                }
            }

            BlockRow {
                StretchText {
                    text: "Color:"
                }
                Rectangle {
                    color: block.color
                    width: 60*dp

                    CustomTouchArea {
                        anchors.fill: parent
                        onClick: colorDialogLoader.active = true
                    }
                }

                Loader {
                    id: colorDialogLoader
                    active: false

                    sourceComponent: ColorDialog {
                        id: colorDialog
                        title: "Please choose a color"
                        color: block.color
                        onAccepted: {
                            block.color = colorDialog.color
                            colorDialogLoader.active = false
                        }
                        onRejected: {
                            colorDialogLoader.active = false
                        }
                        Component.onCompleted: visible = true
                    }
                }
            }

            BlockRow {
                Text {
                    text: "Shadow:"
                    width: parent.width - 30*dp
                }
                CheckBox {
                    id: shadowCheckbox
                    width: 30*dp
                    active: block.shadow
                    onActiveChanged: {
                        if (active !== block.shadow) {
                            block.shadow = active
                        }
                    }
                }
            }

            BlockRow {
                visible: shadowCheckbox.active
                StretchText {
                    text: "Shadow Color:"
                }
                Rectangle {
                    color: block.shadowColor
                    width: 60*dp

                    CustomTouchArea {
                        anchors.fill: parent
                        onClick: shadowColorDialogLoader.active = true
                    }
                }

                Loader {
                    id: shadowColorDialogLoader
                    active: false

                    sourceComponent: ColorDialog {
                        id: shadowColorDialog
                        title: "Please choose a color"
                        color: block.color
                        onAccepted: {
                            block.shadowColor = shadowColorDialog.color
                            shadowColorDialogLoader.active = false
                        }
                        onRejected: {
                            shadowColorDialogLoader.active = false
                        }
                        Component.onCompleted: visible = true
                    }
                }
            }

            BlockRow {
                Text {
                    text: "Bold:"
                    width: parent.width - 30*dp
                }
                CheckBox {
                    width: 30*dp
                    active: block.bold
                    onActiveChanged: {
                        if (active !== block.bold) {
                            block.bold = active
                        }
                    }
                }
            }

            BlockRow {
                Text {
                    text: "Centered:"
                    width: parent.width - 30*dp
                }
                CheckBox {
                    width: 30*dp
                    active: block.centered
                    onActiveChanged: {
                        if (active !== block.centered) {
                            block.centered = active
                        }
                    }
                }
            }

            BlockRow {
                Text {
                    text: "Underline:"
                    width: parent.width - 30*dp
                }
                CheckBox {
                    width: 30*dp
                    active: block.underline
                    onActiveChanged: {
                        if (active !== block.underline) {
                            block.underline = active
                        }
                    }
                }
            }
        }
    }
}

