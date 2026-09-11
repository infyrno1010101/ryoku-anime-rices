import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#050607"
    readonly property real s: Screen.height / 1080
    readonly property color pink: "#ff4d82"
    readonly property color mint: "#9ce3dc"
    readonly property color film: "#eadfc9"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real reel: 0
    property real burn: 0
    property real splice: -0.18
    property real flash: 0
    property int countdown: 5
    property bool authenticating: false

    ListView { id: users; model: typeof userModel !== "undefined" ? userModel : null; currentIndex: root.userIndex; width:1; height:1; opacity:0; delegate: Item { property string uName: model.realName || model.name || ""; property string uLogin: model.name || "" } }
    ListView { id: sessions; model: typeof sessionModel !== "undefined" ? sessionModel : null; currentIndex: root.sessionIndex; width:1; height:1; opacity:0; delegate: Item { property string sName: model.name || "" } }
    Loader { anchors.fill: parent; source: "BackgroundVideo.qml" }
    Rectangle { anchors.fill: parent; color: "#3e000000" }

    NumberAnimation on reel { from: 0; to: 360; duration: 7000; loops: Animation.Infinite }
    SequentialAnimation on burn {
        loops: Animation.Infinite
        PauseAnimation { duration: 4300 }
        NumberAnimation { from: 0; to: 1; duration: 90 }
        PauseAnimation { duration: 130 }
        NumberAnimation { from: 1; to: 0; duration: 150 }
        PauseAnimation { duration: 3320 }
        NumberAnimation { from: 0; to: 1; duration: 90 }
        PauseAnimation { duration: 110 }
        NumberAnimation { from: 1; to: 0; duration: 160 }
        PauseAnimation { duration: 1640 }
    }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.countdown = root.countdown <= 1 ? 5 : root.countdown - 1 }

    // Upper-left projection telemetry.
    Rectangle {
        x: 38 * root.s; y: 38 * root.s; width: 460 * root.s; height: 120 * root.s
        color: "#d9090a0c"; border.width: 2 * root.s; border.color: root.pink; opacity: root.ui
        Text { x: 20*root.s; y: 14*root.s; text: "CHANGEOVER // REEL 03→04"; color: root.pink; font.family: "Noto Sans Mono"; font.pixelSize: 13*root.s; font.bold: true; font.letterSpacing: 2.5*root.s }
        Text { id: clock; x: 20*root.s; y: 43*root.s; text: Qt.formatTime(new Date(), "HH:mm:ss"); color: root.film; font.family: "Noto Sans Mono"; font.pixelSize: 45*root.s; font.bold: true; Timer { interval:1000; running:true; repeat:true; onTriggered: clock.text=Qt.formatTime(new Date(),"HH:mm:ss") } }
        Text { x: 265*root.s; y: 52*root.s; text: "CUE IN 00:0" + root.countdown; color: root.mint; font.family: "Noto Sans Mono"; font.pixelSize: 14*root.s; font.bold:true }
        Rectangle { x:20*root.s; y:99*root.s; width:(420*root.s)*(1-root.countdown/5); height:3*root.s; color:root.mint }
    }

    // Rotating reel instrument on upper-right.
    Item {
        width: 230*root.s; height:230*root.s; anchors.right:parent.right; anchors.rightMargin:42*root.s; anchors.top:parent.top; anchors.topMargin:35*root.s; opacity:root.ui
        Repeater { model:3; Rectangle { id:ring; anchors.centerIn:parent; width:(210-index*55)*root.s; height:width; radius:width/2; color:"transparent"; border.width:(index+1)*root.s; border.color:index===0?root.film:(index===1?root.pink:root.mint); opacity:.58-index*.1; rotation:root.reel*(index%2?-.7:1); Repeater { model:5; Rectangle { property real a:index*Math.PI*2/5; width:13*root.s;height:13*root.s;radius:width/2;color:ring.border.color;x:ring.width/2+Math.cos(a)*ring.width*.36-width/2;y:ring.height/2+Math.sin(a)*ring.height*.36-height/2 } } } }
        Text { anchors.centerIn:parent; text:"24\nFPS"; horizontalAlignment:Text.AlignHCenter; color:root.film; font.family:"Noto Sans Mono"; font.pixelSize:18*root.s; font.bold:true }
    }

    // The two changeover cue marks / cigarette burn.
    Item {
        z:500; anchors.right:parent.right; anchors.rightMargin:58*root.s; anchors.top:parent.top; anchors.topMargin:55*root.s; width:88*root.s;height:88*root.s;opacity:root.burn
        Rectangle { anchors.fill:parent; radius:width/2; color:"#dff7eee0"; layer.enabled:true; layer.effect:DropShadow{radius:35;samples:49;color:"#ffffd36f"} }
        Rectangle { anchors.centerIn:parent; width:54*root.s;height:54*root.s;radius:width/2;color:"#35120d";border.width:7*root.s;border.color:"#fff2d59d" }
        Rectangle { anchors.centerIn:parent; width:23*root.s;height:23*root.s;radius:width/2;color:"#080505" }
    }

    // Film-edge strips preserve the analog projection language.
    Repeater {
        model: 26
        Rectangle { x:index*root.width/26; y:root.height-224*root.s; width:24*root.s; height:13*root.s; radius:2*root.s; color:index%2?"#20eadfc9":"#13ff4d82"; opacity:root.ui }
    }

    // Bottom splice console leaves Tyler and the reels unobstructed.
    Rectangle {
        id: panel; width: 1030*root.s; height:190*root.s; anchors.horizontalCenter:parent.horizontalCenter; anchors.bottom:parent.bottom; anchors.bottomMargin:25*root.s
        color:"#e608090b"; border.width:2*root.s; border.color:root.mint; opacity:root.ui
        Rectangle { anchors.fill:parent; anchors.margins:8*root.s; color:"transparent"; border.width:root.s; border.color:"#55ff4d82" }
        Column { x:24*root.s; y:18*root.s; width:620*root.s; spacing:8*root.s
            Text { text:"IN THE INDUSTRY, WE CALL THEM CIGARETTE BURNS."; color:root.film; font.family:"Noto Sans Mono"; font.pixelSize:11*root.s; font.bold:true; font.letterSpacing:1.8*root.s }
            Text { text:"SPLICE OPERATOR // " + (((users.currentItem&&users.currentItem.uName)?users.currentItem.uName:(typeof userModel!=="undefined"?userModel.lastUser:"TYLER")).toUpperCase()); color:root.pink; font.family:"Noto Sans Mono"; font.pixelSize:14*root.s; font.bold:true; font.letterSpacing:2.4*root.s }
            Rectangle { width:620*root.s;height:58*root.s;color:"#ed020304";border.width:2*root.s;border.color:password.activeFocus?root.mint:root.pink
                TextInput { id:password;anchors.fill:parent;anchors.leftMargin:16*root.s;anchors.rightMargin:170*root.s;echoMode:TextInput.Password;passwordCharacter:"▮";color:root.mint;font.family:"Noto Sans Mono";font.pixelSize:20*root.s;font.letterSpacing:8*root.s;verticalAlignment:TextInput.AlignVCenter;focus:true;enabled:!root.authenticating;onTextEdited:errorText.text="";Keys.onReturnPressed:root.startAuth();Keys.onEnterPressed:root.startAuth() }
                Text { anchors.left:parent.left;anchors.leftMargin:16*root.s;anchors.verticalCenter:parent.verticalCenter;text:"THREAD AUTHENTICATION REEL";visible:password.text.length===0;color:"#617174";font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.letterSpacing:2*root.s }
                Rectangle { width:155*root.s;anchors.top:parent.top;anchors.bottom:parent.bottom;anchors.right:parent.right;color:go.containsMouse?root.pink:"#2b1119";border.width:root.s;border.color:root.pink;Text{anchors.centerIn:parent;text:root.authenticating?"SPLICING…":"CHANGEOVER";color:go.containsMouse?"#10070a":root.pink;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true;font.letterSpacing:1.5*root.s}MouseArea{id:go;anchors.fill:parent;hoverEnabled:true;enabled:!root.authenticating;cursorShape:Qt.PointingHandCursor;onClicked:root.startAuth()} }
                MouseArea { anchors.left:parent.left;anchors.right:parent.right;anchors.rightMargin:160*root.s;anchors.top:parent.top;anchors.bottom:parent.bottom;onClicked:password.forceActiveFocus() }
            }
            Text { id:errorText;text:"";color:root.pink;font.family:"Noto Sans Mono";font.pixelSize:9*root.s;font.bold:true }
        }
        Column { anchors.right:parent.right;anchors.rightMargin:24*root.s;anchors.verticalCenter:parent.verticalCenter;width:315*root.s;spacing:13*root.s
            Text { text:"MOTOR CUE     ● ARMED";color:root.mint;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true }
            Text { text:"CHANGE CUE    ● WAITING";color:root.pink;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true }
            Text { text:"AUDIENCE      UNAWARE";color:root.film;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true }
            Row { spacing:24*root.s;Text{visible:!root.isQuickshell;text:(sessions.currentItem&&sessions.currentItem.sName?sessions.currentItem.sName:"SESSION").toUpperCase();color:root.mint;font.family:"Noto Sans Mono";font.pixelSize:8*root.s}Text{text:"REBOOT";color:root.film;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.reboot()}}Text{text:"SHUTDOWN";color:root.pink;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.powerOff()}} }
        }
    }

    // Unlock slices the physical film diagonally, then burns the frame white.
    Rectangle { z:1000; x:root.splice*root.width; y:-150*root.s; width:130*root.s;height:root.height+300*root.s;rotation:-9;color:root.film;opacity:root.authenticating?.92:0;layer.enabled:true;layer.effect:DropShadow{radius:55;samples:65;color:root.pink} }
    Rectangle { anchors.fill:parent;z:1100;color:root.film;opacity:root.flash }
    NumberAnimation { id:intro;target:root;property:"ui";from:0;to:1;duration:850 }
    ParallelAnimation { id:auth;NumberAnimation{target:root;property:"splice";from:-.18;to:1.18;duration:820;easing.type:Easing.InExpo}SequentialAnimation{PauseAnimation{duration:660}NumberAnimation{target:root;property:"flash";from:0;to:1;duration:130}}onFinished:root.doLogin() }
    Timer { interval:300;running:true;onTriggered:password.forceActiveFocus() } Timer { id:watchdog;interval:8000;onTriggered:root.resetAuth("") }
    Component.onCompleted:{keyboard.numLock=true;intro.start()}
    function startAuth(){if(root.authenticating||password.text.length===0){password.forceActiveFocus();return}root.authenticating=true;root.splice=-.18;root.flash=0;auth.restart()}
    function doLogin(){let u=(users.currentItem&&users.currentItem.uLogin)?users.currentItem.uLogin:(typeof userModel!=="undefined"?userModel.lastUser:"user");if(typeof sddm!=="undefined")sddm.login(u,password.text,root.sessionIndex);watchdog.restart()}
    function resetAuth(m){root.authenticating=false;root.splice=-.18;root.flash=0;password.text="";errorText.text=m;password.forceActiveFocus()}
    Connections { target:typeof sddm!=="undefined"?sddm:null;ignoreUnknownSignals:true;function onLoginFailed(){watchdog.stop();root.resetAuth("BAD SPLICE // REEL REJECTED")}function onLoginSucceeded(){watchdog.stop()}function onInformationMessage(m){errorText.text=(m||"").toUpperCase()}function onErrorMessage(m){errorText.text=(m||"").toUpperCase()} }
}
