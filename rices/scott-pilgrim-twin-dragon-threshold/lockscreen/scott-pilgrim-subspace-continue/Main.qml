import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#060711"
    readonly property real s: Screen.height / 1080
    readonly property color pink: "#ff3f70"
    readonly property color cyan: "#56e1f5"
    readonly property color yellow: "#ffe43b"
    readonly property color green: "#62ff79"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real spin: 0
    property real portal: 0
    property real flash: 0
    property int continueCount: 5
    property bool authenticating: false

    FontLoader { id: arcade; source: "PressStart2P-Regular.ttf" }
    FontLoader { id: caption; source: "ArchivoNarrow.ttf" }
    ListView { id:users;model:typeof userModel!=="undefined"?userModel:null;currentIndex:root.userIndex;width:1;height:1;opacity:0;delegate:Item{property string uName:model.realName||model.name||"";property string uLogin:model.name||""} }
    ListView { id:sessions;model:typeof sessionModel!=="undefined"?sessionModel:null;currentIndex:root.sessionIndex;width:1;height:1;opacity:0;delegate:Item{property string sName:model.name||""} }
    Loader { anchors.fill:parent; source:"BackgroundVideo.qml" }
    Rectangle { anchors.fill:parent;color:"#3a020410" }
    NumberAnimation on spin { from:0;to:360;duration:17000;loops:Animation.Infinite }
    Timer { interval:1000;running:true;repeat:true;onTriggered:root.continueCount=root.continueCount<=1?5:root.continueCount-1 }

    Image {
        source:"Scott_Pilgrim_vs_the_World_Wordmark.svg";width:350*root.s;height:175*root.s;fillMode:Image.PreserveAspectFit
        anchors.left:parent.left;anchors.leftMargin:38*root.s;anchors.top:parent.top;anchors.topMargin:25*root.s;opacity:root.ui
        layer.enabled:true;layer.effect:DropShadow{radius:18;samples:25;color:"#c0ff3f70"}
    }

    // Seven evil ex progress rail.
    Column {
        x:42*root.s;y:250*root.s;spacing:12*root.s;opacity:root.ui
        Text{text:"LEAGUE STATUS";color:root.yellow;font.family:arcade.name;font.pixelSize:9*root.s}
        Repeater { model:7;Row{spacing:10*root.s;Rectangle{width:22*root.s;height:22*root.s;radius:4*root.s;color:index<6?root.pink:"#2f1830";border.width:2*root.s;border.color:index<6?"white":root.pink;Text{anchors.centerIn:parent;text:index<6?"×":"7";color:"white";font.family:arcade.name;font.pixelSize:8*root.s}}Text{text:"EVIL EX 0"+(index+1)+(index<6?"  K.O.":"  CLEARED");color:index<6?"#e8edf3":root.green;font.family:arcade.name;font.pixelSize:7*root.s;anchors.verticalCenter:parent.verticalCenter}} }
    }

    // Continue panel, kept right of the central subspace door.
    Rectangle {
        id:panel;width:430*root.s;height:500*root.s;anchors.right:parent.right;anchors.rightMargin:38*root.s;anchors.verticalCenter:parent.verticalCenter
        color:"#dc070817";border.width:4*root.s;border.color:root.cyan;opacity:root.ui;rotation:-1.2
        Rectangle{anchors.fill:parent;anchors.margins:9*root.s;color:"transparent";border.width:2*root.s;border.color:root.pink}
        Column { width:360*root.s;anchors.centerIn:parent;spacing:15*root.s
            Text{text:"CONTINUE?";color:root.yellow;font.family:arcade.name;font.pixelSize:29*root.s;anchors.horizontalCenter:parent.horizontalCenter;layer.enabled:true;layer.effect:DropShadow{radius:16;samples:21;color:root.pink}}
            Text{text:String(root.continueCount);color:root.green;font.family:arcade.name;font.pixelSize:64*root.s;anchors.horizontalCenter:parent.horizontalCenter}
            Row{anchors.horizontalCenter:parent.horizontalCenter;spacing:16*root.s;Text{text:"★";color:root.yellow;font.pixelSize:30*root.s}Text{text:"1-UP READY";color:root.cyan;font.family:arcade.name;font.pixelSize:11*root.s;anchors.verticalCenter:parent.verticalCenter}}
            Rectangle{width:360*root.s;height:2*root.s;color:root.pink}
            Text{text:"PLAYER";color:"#9ca5bb";font.family:arcade.name;font.pixelSize:8*root.s}
            Text{text:(((users.currentItem&&users.currentItem.uName)?users.currentItem.uName:(typeof userModel!=="undefined"?userModel.lastUser:"SCOTT")).toUpperCase());color:"white";font.family:caption.name;font.pixelSize:30*root.s;font.bold:true;font.letterSpacing:2*root.s}
            Rectangle { width:360*root.s;height:62*root.s;color:"#f0030410";border.width:3*root.s;border.color:password.activeFocus?root.yellow:root.cyan
                TextInput{id:password;anchors.fill:parent;anchors.leftMargin:16*root.s;anchors.rightMargin:16*root.s;echoMode:TextInput.Password;passwordCharacter:"★";color:root.yellow;font.family:arcade.name;font.pixelSize:16*root.s;font.letterSpacing:7*root.s;verticalAlignment:TextInput.AlignVCenter;focus:true;enabled:!root.authenticating;onTextEdited:errorText.text="";Keys.onReturnPressed:root.startAuth();Keys.onEnterPressed:root.startAuth()}
                Text{anchors.left:parent.left;anchors.leftMargin:16*root.s;anchors.verticalCenter:parent.verticalCenter;text:"INSERT AUTH CODE";visible:password.text.length===0;color:"#677087";font.family:arcade.name;font.pixelSize:7*root.s}
                MouseArea{anchors.fill:parent;onClicked:password.forceActiveFocus()}
            }
            Rectangle{width:360*root.s;height:56*root.s;color:go.containsMouse?root.green:"#15351f";border.width:3*root.s;border.color:root.green;Text{anchors.centerIn:parent;text:root.authenticating?"ENTERING SUBSPACE…":"YES  /  ENTER";color:go.containsMouse?"#050711":root.green;font.family:arcade.name;font.pixelSize:9*root.s}MouseArea{id:go;anchors.fill:parent;hoverEnabled:true;enabled:!root.authenticating;cursorShape:Qt.PointingHandCursor;onClicked:root.startAuth()}}
            Text{id:errorText;text:"";color:root.pink;font.family:arcade.name;font.pixelSize:7*root.s;anchors.horizontalCenter:parent.horizontalCenter}
            Row{anchors.horizontalCenter:parent.horizontalCenter;spacing:22*root.s;Text{visible:!root.isQuickshell;text:(sessions.currentItem&&sessions.currentItem.sName?sessions.currentItem.sName:"SESSION").toUpperCase();color:root.cyan;font.family:arcade.name;font.pixelSize:6*root.s}Text{text:"REBOOT";color:"white";font.family:arcade.name;font.pixelSize:6*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.reboot()}}Text{text:"QUIT";color:root.pink;font.family:arcade.name;font.pixelSize:6*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.powerOff()}}}
        }
    }

    // Power-of-self-respect status and portal rings around the actual door.
    Item { width:390*root.s;height:630*root.s;x:(root.width-width)/2-30*root.s;y:(root.height-height)/2;opacity:root.ui
        Repeater{model:5;Rectangle{anchors.centerIn:parent;width:(360-index*42)*root.s;height:(600-index*70)*root.s;radius:16*root.s;color:"transparent";border.width:(index%2?2:4)*root.s;border.color:index%2?root.pink:root.cyan;opacity:.20-index*.025;rotation:root.spin*(index%2?-.12:.09)}}
        Text{anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:parent.bottom;anchors.bottomMargin:5*root.s;text:"POWER OF SELF-RESPECT";color:root.yellow;font.family:arcade.name;font.pixelSize:7*root.s}
    }

    // Pixel portal shatter during authentication.
    Repeater { model:48;Rectangle{z:1000;property real a:index*Math.PI*2/48;width:(6+index%5*4)*root.s;height:width;color:index%3===0?root.pink:(index%3===1?root.cyan:root.yellow);x:root.width/2+Math.cos(a)*root.portal*root.width*.72;y:root.height/2+Math.sin(a)*root.portal*root.height*.72;rotation:root.portal*720+index*17;opacity:root.authenticating?(1-root.portal*.55):0} }
    Rectangle{anchors.fill:parent;z:1100;color:"white";opacity:root.flash}
    NumberAnimation{id:intro;target:root;property:"ui";from:0;to:1;duration:700}
    ParallelAnimation{id:auth;NumberAnimation{target:root;property:"portal";from:0;to:1;duration:820;easing.type:Easing.OutExpo}SequentialAnimation{PauseAnimation{duration:650}NumberAnimation{target:root;property:"flash";from:0;to:1;duration:130}}onFinished:root.doLogin()}
    Timer{interval:300;running:true;onTriggered:password.forceActiveFocus()}Timer{id:watchdog;interval:8000;onTriggered:root.resetAuth("")}
    Component.onCompleted:{keyboard.numLock=true;intro.start()}
    function startAuth(){if(root.authenticating||password.text.length===0){password.forceActiveFocus();return}root.authenticating=true;root.portal=0;root.flash=0;auth.restart()}
    function doLogin(){let u=(users.currentItem&&users.currentItem.uLogin)?users.currentItem.uLogin:(typeof userModel!=="undefined"?userModel.lastUser:"user");if(typeof sddm!=="undefined")sddm.login(u,password.text,root.sessionIndex);watchdog.restart()}
    function resetAuth(m){root.authenticating=false;root.portal=0;root.flash=0;password.text="";errorText.text=m;password.forceActiveFocus()}
    Connections{target:typeof sddm!=="undefined"?sddm:null;ignoreUnknownSignals:true;function onLoginFailed(){watchdog.stop();root.resetAuth("GAME OVER // TRY AGAIN")}function onLoginSucceeded(){watchdog.stop()}function onInformationMessage(m){errorText.text=(m||"").toUpperCase()}function onErrorMessage(m){errorText.text=(m||"").toUpperCase()}}
}
