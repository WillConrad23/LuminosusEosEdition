import QtQuick 2.5
import CustomElements 1.0
import QtGraphicalEffects 1.0
import "../../CustomBasics"
import "../../CustomControls"

BlockBase {
    id: root
    width: 90*dp
    height: 60*dp
    settingsComponent: settings

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: -20*dp
        width: 2*dp
        height: 20*dp
        color: "#333"
    }
    Rectangle {
        id: colorCircle
        anchors.horizontalCenter: parent.horizontalCenter
        y: -48*dp

        width: 40*dp
        height: 40*dp
        radius: 20*dp
        color: block.attr("resultColor").qcolor
    }
    Image {
        id: glowImage
        anchors.centerIn: colorCircle
        width: 100*dp
        height: 100*dp
        source: "qrc:/images/light_glow.png"
        visible: false
    }
    ColorOverlay {
        anchors.fill: glowImage
        source: glowImage
        color: block.attr("resultColor").glow
        opacity:block.attr("resultColor").max
    }
    Image {
        anchors.fill: colorCircle
        source: "qrc:/images/light_glow_foreground.png"
        opacity: block.attr("resultColor").max * 0.4
    }

    StretchColumn {
        anchors.fill: parent

        BlockRow {
            InputNode {
                node: block.node("inputNode")
                width: 15*dp
            }
            ButtonBottomLine {
                width: 30*dp
                implicitWidth: 0
                text: block.attr("benchEffects").val > 0.0 ? "E" : "S"
                onPress: block.toggleBenchEffects();
                mappingID: block.getUid() + block.attr("benchEffects").name()
            }
            DotBrightnessSlider {
                width: 30*dp
                displayColor: block.attr("benchColor").qcolor
                value: block.attr("benchColor").max
                onValueChanged: {
                    if (value !== block.attr("benchColor").max) {
                        block.setBrightness(value)
                    }
                }
                mappingID: block.getUid() + "benchColor"
            }
            // ---------------------------
            OutputNode {
                node: block.node("outputNode")
                width: 15*dp
            }
        }

        DragArea {
            id: dragarea
            text: block.label || block.attr("address").val.toFixed(0)
        }
    }  // end main column

    Component {
        id: settings
        StretchColumn {
            leftMargin: 15*dp
            rightMargin: 15*dp
            defaultSize: 30*dp

            BlockRow {
                StretchText {
                    text: "Address:"
                }
                AttributeNumericInput {
                    width: 60*dp
                    attr: block.attr("address")
                }
            }

            BlockRow {
                StretchText {
                    text: "Gamma:"
                }
                AttributeNumericInput {
                    width: 60*dp
                    attr: block.attr("gamma")
                    decimals: 1
                }
            }

            BlockRow {
                StretchText {
                    text: "Current Effects:"
                }
                Text {
                    width: 50*dp
                    text: (block.attr("resultEffects").val * 100).toFixed(0) + "%"
                }
            }
        }
    }
}

