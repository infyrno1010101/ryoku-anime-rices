import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#050b0d"
    readonly property real s: Screen.height / 1080
    readonly property color gold: "#e6c54f"
    readonly property color ice: "#bff7fa"
    readonly property color teal: "#69d3da"
    readonly property color black: "#050b0d"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real dial: 0
    property real jewel: 1
    property real burst: 0
    property real flash: 0
    property bool authenticating: false
    ListView{id:users;model:typeof userModel!=="undefined"?userModel:null;currentIndex:root.userIndex;width:1;height:1;opacity:0;delegate:Item{property string uName:model.realName||model.name||"";property string uLogin:model.name||""}}
    ListView{id:sessions;model:typeof sessionModel!=="undefined"?sessionModel:null;currentIndex:root.sessionIndex;width:1;height:1;opacity:0;delegate:Item{property string sName:model.name||""}}
    Loader{anchors.fill:parent;source:"BackgroundVideo.qml"}
    Rectangle{anchors.fill:parent;color:"#43000000"}
    NumberAnimation on dial{from:0;to:360;duration:22000;loops:Animation.Infinite}

    // Film title and round counter, left rail.
    Column {
        x:45*root.s;y:45*root.s;width:330*root.s;spacing:8*root.s;opacity:root.ui
        Text{text:"SNATCH.";color:root.gold;font.family:"Noto Sans";font.pixelSize:76*root.s;font.bold:true;font.letterSpacing:-4*root.s}
        Rectangle{width:310*root.s;height:3*root.s;color:root.teal}
        Text{text:"STEALIN' STONES\nAND BREAKIN' BONES";color:root.ice;font.family:"Noto Sans Mono";font.pixelSize:16*root.s;font.bold:true;font.letterSpacing:3*root.s;lineHeight:1.35}
        Text{id:clock;text:Qt.formatTime(new Date(),"HH:mm:ss");color:root.teal;font.family:"Noto Sans Mono";font.pixelSize:23*root.s;font.bold:true;Timer{interval:1000;running:true;repeat:true;onTriggered:clock.text=Qt.formatTime(new Date(),"HH:mm:ss")}}
    }

    // Safe dial around the diamond centre.
    Item {
        id:vault;anchors.centerIn:parent;width:540*root.s;height:540*root.s;opacity:root.ui;scale:root.jewel
        Repeater{model:5;Rectangle{anchors.centerIn:parent;width:(520-index*58)*root.s;height:width;radius:width/2;color:"transparent";border.width:(index%2?1:3)*root.s;border.color:index%2?root.teal:root.gold;opacity:.34-index*.035;rotation:root.dial*(index%2?-.6:1)+index*43;Rectangle{width:10*root.s;height:10*root.s;radius:width/2;anchors.horizontalCenter:parent.horizontalCenter;y:-height/2;color:parent.border.color}}}
        Repeater{model:24;Text{property real a:(index*15+root.dial)*Math.PI/180;x:vault.width/2+Math.cos(a)*235*root.s-width/2;y:vault.height/2+Math.sin(a)*235*root.s-height/2;text:String(index).padStart(2,'0');color:index%4===0?root.gold:"#668da0a3";font.family:"Noto Sans Mono";font.pixelSize:8*root.s;rotation:index*15+root.dial+90}}
        Text{anchors.centerIn:parent;text:"84";color:root.ice;font.family:"Noto Sans Mono";font.pixelSize:68*root.s;font.bold:true;layer.enabled:true;layer.effect:DropShadow{radius:25;samples:33;color:root.teal}}
        Text{anchors.horizontalCenter:parent.horizontalCenter;anchors.top:parent.verticalCenter;anchors.topMargin:60*root.s;text:"CARATS";color:root.gold;font.family:"Noto Sans Mono";font.pixelSize:13*root.s;font.bold:true;font.letterSpacing:4*root.s}
    }

    // Pawprints orbit the vault independently from the background video.
    Repeater {
        model:14
        Item { property real a:(index*Math.PI*2/14)-root.dial*Math.PI/540; x:root.width/2+Math.cos(a)*330*root.s; y:root.height/2+Math.sin(a)*250*root.s; width:18*root.s;height:18*root.s;opacity:.65*root.ui
            Rectangle{width:8*root.s;height:7*root.s;radius:width/2;color:root.gold;anchors.centerIn:parent}
            Repeater{model:3;Rectangle{width:4*root.s;height:5*root.s;radius:width/2;color:root.gold;x:(3+index*5)*root.s;y:0}}
        }
    }

    // Compact vault keypad on the right, visually unlike the other two locks.
    Rectangle {
        id:panel;width:365*root.s;height:350*root.s;anchors.right:parent.right;anchors.rightMargin:45*root.s;anchors.verticalCenter:parent.verticalCenter;color:"#df071012";border.width:2*root.s;border.color:root.teal;opacity:root.ui
        Column{width:310*root.s;anchors.centerIn:parent;spacing:13*root.s
            Text{text:"VAULT HOLDER";color:root.gold;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true;font.letterSpacing:3*root.s}
            Text{text:(((users.currentItem&&users.currentItem.uName)?users.currentItem.uName:(typeof userModel!=="undefined"?userModel.lastUser:"TURKISH")).toUpperCase());color:root.ice;font.family:"Noto Sans Mono";font.pixelSize:24*root.s;font.bold:true;font.letterSpacing:4*root.s}
            Text{text:"THE DOG HAS THE STONE.\nOPEN THE VAULT BEFORE AVI RETURNS.";color:"#8fb5b7";font.family:"Noto Sans Mono";font.pixelSize:9*root.s;lineHeight:1.4;font.letterSpacing:1.2*root.s}
            Rectangle{width:310*root.s;height:56*root.s;color:"#ee04090a";border.width:2*root.s;border.color:password.activeFocus?root.gold:root.teal
                TextInput{id:password;anchors.fill:parent;anchors.leftMargin:15*root.s;anchors.rightMargin:15*root.s;echoMode:TextInput.Password;passwordCharacter:"◆";color:root.ice;font.family:"Noto Sans Mono";font.pixelSize:18*root.s;font.letterSpacing:8*root.s;verticalAlignment:TextInput.AlignVCenter;focus:true;enabled:!root.authenticating;onTextEdited:errorText.text="";Keys.onReturnPressed:root.startAuth();Keys.onEnterPressed:root.startAuth()}
                Text{anchors.left:parent.left;anchors.leftMargin:15*root.s;anchors.verticalCenter:parent.verticalCenter;text:"ENTER DIAMOND CUT";visible:password.text.length===0;color:"#526d70";font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.letterSpacing:2*root.s}
                MouseArea{anchors.fill:parent;onClicked:password.forceActiveFocus()}
            }
            Rectangle{width:310*root.s;height:48*root.s;color:open.containsMouse?root.gold:"#241d0a";border.width:2*root.s;border.color:root.gold;Text{anchors.centerIn:parent;text:root.authenticating?"CUTTING…":"OPEN / UNLOCK";color:open.containsMouse?root.black:root.gold;font.family:"Noto Sans Mono";font.pixelSize:11*root.s;font.bold:true;font.letterSpacing:2*root.s}MouseArea{id:open;anchors.fill:parent;hoverEnabled:true;enabled:!root.authenticating;cursorShape:Qt.PointingHandCursor;onClicked:root.startAuth()}}
            Text{id:errorText;text:"";color:"#e77855";font.family:"Noto Sans Mono";font.pixelSize:9*root.s;font.bold:true}
            Row{spacing:18*root.s;Text{visible:!root.isQuickshell;text:(sessions.currentItem&&sessions.currentItem.sName?sessions.currentItem.sName:"SESSION").toUpperCase();color:root.teal;font.family:"Noto Sans Mono";font.pixelSize:8*root.s}Text{text:"REBOOT";color:root.ice;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.reboot()}}Text{text:"SHUTDOWN";color:root.gold;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.powerOff()}}}
        }
    }

    // Diamond burst unlock—facets explode radially.
    Repeater{model:24;Rectangle{z:1000;property real a:index*Math.PI*2/24;width:7*root.s;height:(55+index%5*25)*root.s;x:root.width/2+Math.cos(a)*root.burst*root.width*.8;y:root.height/2+Math.sin(a)*root.burst*root.height*.8;rotation:a*180/Math.PI;color:index%2?root.gold:root.teal;opacity:root.authenticating?(1-root.burst*.55):0}}
    Rectangle{anchors.fill:parent;z:1100;color:root.ice;opacity:root.flash}
    NumberAnimation{id:intro;target:root;property:"ui";from:0;to:1;duration:900}
    ParallelAnimation{id:auth;NumberAnimation{target:root;property:"burst";from:0;to:1;duration:850;easing.type:Easing.OutExpo}NumberAnimation{target:root;property:"jewel";from:1;to:3.5;duration:850;easing.type:Easing.InExpo}SequentialAnimation{PauseAnimation{duration:680}NumberAnimation{target:root;property:"flash";from:0;to:1;duration:140}}onFinished:root.doLogin()}
    Timer{interval:300;running:true;onTriggered:password.forceActiveFocus()}Timer{id:watchdog;interval:8000;onTriggered:root.resetAuth("")}
    Component.onCompleted:{keyboard.numLock=true;intro.start()}
    function startAuth(){if(root.authenticating||password.text.length===0){password.forceActiveFocus();return}root.authenticating=true;root.burst=0;root.jewel=1;root.flash=0;auth.restart()}
    function doLogin(){let u=(users.currentItem&&users.currentItem.uLogin)?users.currentItem.uLogin:(typeof userModel!=="undefined"?userModel.lastUser:"user");if(typeof sddm!=="undefined")sddm.login(u,password.text,root.sessionIndex);watchdog.restart()}
    function resetAuth(m){root.authenticating=false;root.burst=0;root.jewel=1;root.flash=0;password.text="";errorText.text=m;password.forceActiveFocus()}
    Connections{target:typeof sddm!=="undefined"?sddm:null;ignoreUnknownSignals:true;function onLoginFailed(){watchdog.stop();root.resetAuth("WRONG CUT // STONE LOCKED")}function onLoginSucceeded(){watchdog.stop()}function onInformationMessage(m){errorText.text=(m||"").toUpperCase()}function onErrorMessage(m){errorText.text=(m||"").toUpperCase()}}
}
