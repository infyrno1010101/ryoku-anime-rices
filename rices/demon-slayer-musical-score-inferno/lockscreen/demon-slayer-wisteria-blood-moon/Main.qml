import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#07050a"

    readonly property real s: Screen.height / 1080
    readonly property color gold: "#f4cf46"
    readonly property color wisteria: "#a978ff"
    readonly property color mint: "#6ff0c2"
    readonly property color blood: "#e73736"
    readonly property color paper: "#fff5dc"
    readonly property color ink: "#130d17"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real breath: 0
    property real ring: 0
    property bool authenticating: false
    property real slash: -0.25
    property real flash: 0
    property real altarShake: 0

    ListView {
        id: userHelper; model: typeof userModel !== "undefined" ? userModel : null; currentIndex: root.userIndex; width: 1; height: 1; opacity: 0
        delegate: Item { property string uName: model.realName || model.name || ""; property string uLogin: model.name || "" }
    }
    ListView {
        id: sessionHelper; model: typeof sessionModel !== "undefined" ? sessionModel : null; currentIndex: root.sessionIndex; width: 1; height: 1; opacity: 0
        delegate: Item { property string sName: model.name || "" }
    }

    Loader { anchors.fill: parent; source: "BackgroundVideo.qml" }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4808050b" }
            GradientStop { position: 0.48; color: "#0808050b" }
            GradientStop { position: 1.0; color: "#b307050a" }
        }
    }
    Rectangle {
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 340 * root.s
        gradient: Gradient {
            GradientStop { position: 0; color: "#0007050a" }
            GradientStop { position: 1; color: "#ef07050a" }
        }
    }

    NumberAnimation on breath { from: 0; to: 1; duration: 4200; loops: Animation.Infinite; easing.type: Easing.InOutSine }
    NumberAnimation on ring { from: 0; to: 360; duration: 30000; loops: Animation.Infinite }

    // Wisteria seal and vertical title—a composition wholly unlike the
    // Edgerunners terminal lockscreen.
    Rectangle {
        x: 52 * root.s; y: 54 * root.s; width: 132 * root.s; height: 390 * root.s
        color: "#a00a0710"; border.width: 2 * root.s; border.color: root.wisteria; opacity: root.ui
        Rectangle { anchors.fill: parent; anchors.margins: 8 * root.s; color: "transparent"; border.width: root.s; border.color: "#72f4cf46" }
        Column {
            anchors.centerIn: parent; spacing: 2 * root.s
            Repeater {
                model: ["鬼", "滅", "の", "刃"]
                Text { text: modelData; color: index === 2 ? root.gold : root.paper; font.family: "Noto Serif CJK JP"; font.pixelSize: (index === 2 ? 32 : 58) * root.s; font.bold: true; horizontalAlignment: Text.AlignHCenter; width: 100 * root.s }
            }
        }
        Rectangle { width: 36 * root.s; height: 36 * root.s; radius: 4 * root.s; color: root.blood; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 22 * root.s
            Text { anchors.centerIn: parent; text: "音"; color: root.paper; font.family: "Noto Serif CJK JP"; font.pixelSize: 21 * root.s; font.bold: true }
        }
    }

    // Moon clock with rotating breathing forms.
    Item {
        anchors.right: parent.right; anchors.rightMargin: 70 * root.s; anchors.top: parent.top; anchors.topMargin: 52 * root.s
        width: 310 * root.s; height: 310 * root.s; opacity: root.ui
        Repeater {
            model: 6
            Rectangle {
                anchors.centerIn: parent; width: (290-index*34) * root.s; height: width; radius: width/2; color: "transparent"; border.width: (index%3===0?2:1)*root.s
                border.color: index%3===0 ? root.gold : (index%3===1 ? root.wisteria : root.mint); opacity: .28-index*.025; rotation: root.ring*(index%2 ? -.55 : .72)+index*31
                Rectangle { width: (index%2?7:11)*root.s; height: width; radius: width/2; anchors.horizontalCenter: parent.horizontalCenter; y: -height/2; color: parent.border.color }
            }
        }
        Text { id: clock; anchors.centerIn: parent; text: Qt.formatTime(new Date(),"HH:mm"); color: root.paper; font.family: "Noto Serif"; font.pixelSize: 66*root.s; font.bold: true
            Timer { interval: 1000; running: true; repeat: true; onTriggered: clock.text=Qt.formatTime(new Date(),"HH:mm") }
        }
        Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: clock.bottom; anchors.topMargin: 8*root.s; text: "WISTERIA BREATH // NIGHT WATCH"; color: root.mint; font.family: "Noto Sans Mono"; font.pixelSize: 10*root.s; font.letterSpacing: 2*root.s }
    }

    // Decorative breathing waveform across the horizon.
    Item {
        anchors.left: parent.left; anchors.right: parent.right; y: parent.height*.58; height: 90*root.s; opacity: .52*root.ui
        Repeater {
            model: 72
            Rectangle {
                width: 3*root.s; radius: width/2; anchors.verticalCenter: parent.verticalCenter
                x: index*(root.width/72); height: (8+50*Math.abs(Math.sin(index*.31+root.breath*Math.PI*2))*Math.abs(Math.sin(index*.08+root.breath*Math.PI)))*root.s
                color: index%4===0 ? root.gold : (index%2 ? root.wisteria : root.mint)
            }
        }
    }

    // Shoji authentication altar at bottom center.
    Rectangle {
        id: altar
        width: 760*root.s; height: 255*root.s
        anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 28*root.s
        x: root.altarShake
        color: "#dc0b0810"; border.width: 2*root.s; border.color: root.gold; opacity: root.ui
        Rectangle { anchors.fill: parent; anchors.margins: 8*root.s; color: "transparent"; border.width: root.s; border.color: "#69a978ff" }
        Repeater { model: 6; Rectangle { x: (index+1)*parent.width/7; y: 10*root.s; width: root.s; height: parent.height-20*root.s; color: "#35fff5dc" } }
        Repeater { model: 2; Rectangle { x: 10*root.s; y: (index+1)*parent.height/3; width: parent.width-20*root.s; height: root.s; color: "#35fff5dc" } }

        Column {
            width: 650*root.s; anchors.centerIn: parent; spacing: 10*root.s
            Row {
                width: parent.width; spacing: 12*root.s
                Text { text: root.authenticating ? "譜" : "守"; color: root.authenticating ? root.blood : root.gold; font.family: "Noto Serif CJK JP"; font.pixelSize: 30*root.s; font.bold: true }
                Column {
                    spacing: 2*root.s
                    Text { text: root.authenticating ? "MUSICAL SCORE AUTHENTICATION" : "WISTERIA ESTATE // PROTECTED"; color: root.paper; font.family: "Noto Sans Mono"; font.pixelSize: 13*root.s; font.bold: true; font.letterSpacing: 2*root.s }
                    Text { text: "SLAYER  " + (((userHelper.currentItem && userHelper.currentItem.uName)?userHelper.currentItem.uName:(typeof userModel!=="undefined"?userModel.lastUser:"USER")).toUpperCase()); color: root.mint; font.family: "Noto Sans Mono"; font.pixelSize: 10*root.s; font.letterSpacing: 2*root.s }
                }
            }
            Item {
                width: parent.width; height: 56*root.s
                Rectangle { anchors.fill: parent; color: "#bb07050a"; border.width: 2*root.s; border.color: password.activeFocus ? root.gold : root.wisteria }
                Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; width: parent.width*(password.text.length>0?Math.min(1,password.text.length/12):.05); height: 4*root.s; color: password.text.length<8?root.mint:root.blood; Behavior on width { NumberAnimation { duration: 100 } } }
                TextInput {
                    id: password; anchors.fill: parent; anchors.leftMargin: 20*root.s; anchors.rightMargin: 160*root.s; echoMode: TextInput.Password; passwordCharacter: "●"; color: root.paper; font.family: "Noto Sans Mono"; font.pixelSize: 20*root.s; font.letterSpacing: 9*root.s; verticalAlignment: TextInput.AlignVCenter; focus: true; enabled: !root.authenticating; cursorVisible: true; selectionColor: root.wisteria
                    onTextEdited: errorText.text=""; Keys.onReturnPressed: root.startAuth(); Keys.onEnterPressed: root.startAuth()
                }
                Text { anchors.left: parent.left; anchors.leftMargin: 20*root.s; anchors.verticalCenter: parent.verticalCenter; text: "ENTER CORPS SEAL"; visible: password.text.length===0; color: "#8a8190"; font.family: "Noto Sans Mono"; font.pixelSize: 11*root.s; font.letterSpacing: 3*root.s }
                Rectangle {
                    width: 145*root.s; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right; color: unlockMouse.containsMouse?root.gold:"#331d1821"; border.width: root.s; border.color: root.gold
                    Text { anchors.centerIn: parent; text: root.authenticating?"BREATHING…":"UNSHEATHE"; color: unlockMouse.containsMouse?root.ink:root.gold; font.family: "Noto Sans Mono"; font.pixelSize: 11*root.s; font.bold: true; font.letterSpacing: 2*root.s }
                    MouseArea { id: unlockMouse; anchors.fill: parent; hoverEnabled: true; enabled: !root.authenticating; cursorShape: Qt.PointingHandCursor; onClicked: root.startAuth() }
                }
                MouseArea { anchors.left: parent.left; anchors.right: parent.right; anchors.rightMargin: 150*root.s; anchors.top: parent.top; anchors.bottom: parent.bottom; onClicked: password.forceActiveFocus() }
            }
            Row {
                width: parent.width
                Text { id:errorText; width: 390*root.s; text:""; color:root.blood; font.family:"Noto Sans Mono"; font.pixelSize:10*root.s; font.bold:true; font.letterSpacing:1.5*root.s }
                Row {
                    spacing: 20*root.s
                    Text { visible:!root.isQuickshell; text:(sessionHelper.currentItem&&sessionHelper.currentItem.sName?sessionHelper.currentItem.sName:"SESSION").toUpperCase(); color:sessionMouse.containsMouse?root.gold:"#998da3"; font.family:"Noto Sans Mono"; font.pixelSize:9*root.s; MouseArea{id:sessionMouse;anchors.fill:parent;hoverEnabled:true;onClicked:if(typeof sessionModel!=="undefined"&&sessionModel.rowCount()>0)root.sessionIndex=(root.sessionIndex+1)%sessionModel.rowCount()} }
                    Text { text:"REBOOT"; color:rebootMouse.containsMouse?root.gold:"#998da3"; font.family:"Noto Sans Mono"; font.pixelSize:9*root.s; MouseArea{id:rebootMouse;anchors.fill:parent;hoverEnabled:true;onClicked:if(typeof sddm!=="undefined")sddm.reboot()} }
                    Text { text:"SHUTDOWN"; color:offMouse.containsMouse?root.blood:"#998da3"; font.family:"Noto Sans Mono"; font.pixelSize:9*root.s; MouseArea{id:offMouse;anchors.fill:parent;hoverEnabled:true;onClicked:if(typeof sddm!=="undefined")sddm.powerOff()} }
                }
            }
        }
    }

    // Hinokami diagonal unlock slash.
    Item {
        anchors.fill: parent; z: 1000; opacity: root.authenticating?1:0
        Rectangle { width: 70*root.s; height: root.height*2; x: root.slash*root.width; y:-root.height*.5; rotation:-32; color:root.blood; opacity:.78; layer.enabled:true; layer.effect:DropShadow{radius:42;samples:49;color:"#ffffb52f"} }
        Rectangle { width: 18*root.s; height: root.height*2; x: root.slash*root.width+38*root.s; y:-root.height*.5; rotation:-32; color:root.paper }
    }
    Rectangle { anchors.fill: parent; z: 1100; color: root.paper; opacity: root.flash }

    NumberAnimation { id:intro;target:root;property:"ui";from:0;to:1;duration:1000;easing.type:Easing.OutCubic }
    ParallelAnimation {
        id:authAnim
        NumberAnimation{target:root;property:"slash";from:-.25;to:1.25;duration:820;easing.type:Easing.InExpo}
        SequentialAnimation{PauseAnimation{duration:660} NumberAnimation{target:root;property:"flash";from:0;to:1;duration:150}}
        onFinished:root.doLogin()
    }
    SequentialAnimation{id:denyShake;NumberAnimation{target:root;property:"altarShake";to:16*root.s;duration:45}NumberAnimation{target:root;property:"altarShake";to:-14*root.s;duration:50}NumberAnimation{target:root;property:"altarShake";to:9*root.s;duration:50}NumberAnimation{target:root;property:"altarShake";to:0;duration:70}}
    Timer{interval:320;running:true;onTriggered:password.forceActiveFocus()}
    Timer{id:watchdog;interval:8000;onTriggered:root.resetAuth("")}
    Component.onCompleted:{keyboard.numLock=true;intro.start()}
    function startAuth(){if(root.authenticating||password.text.length===0){password.forceActiveFocus();return}root.authenticating=true;root.slash=-.25;root.flash=0;authAnim.restart()}
    function doLogin(){let u=(userHelper.currentItem&&userHelper.currentItem.uLogin)?userHelper.currentItem.uLogin:(typeof userModel!=="undefined"?userModel.lastUser:"user");if(typeof sddm!=="undefined")sddm.login(u,password.text,root.sessionIndex);watchdog.restart()}
    function resetAuth(msg){root.authenticating=false;root.slash=-.25;root.flash=0;password.text="";errorText.text=msg;password.forceActiveFocus()}
    Connections{target:typeof sddm!=="undefined"?sddm:null;ignoreUnknownSignals:true;function onLoginFailed(){watchdog.stop();root.resetAuth("SEAL REJECTED // STEADY YOUR BREATH");denyShake.restart()}function onLoginSucceeded(){watchdog.stop()}function onInformationMessage(m){errorText.text=(m||"").toUpperCase()}function onErrorMessage(m){errorText.text=(m||"").toUpperCase()}}
}
