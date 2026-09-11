import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#182d24"
    readonly property real s: Screen.height / 1080
    readonly property color brass: "#e6c06e"
    readonly property color felt: "#1e3a2c"
    readonly property color blood: "#b94736"
    readonly property color paper: "#eee0bd"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real dial: 0
    property real shuffle: 0
    property real flash: 0
    property bool authenticating: false
    ListView { id: users; model: typeof userModel !== "undefined" ? userModel : null; currentIndex: root.userIndex; width:1;height:1;opacity:0; delegate:Item{property string uName:model.realName||model.name||"";property string uLogin:model.name||""} }
    ListView { id: sessions; model: typeof sessionModel !== "undefined" ? sessionModel : null; currentIndex: root.sessionIndex; width:1;height:1;opacity:0; delegate:Item{property string sName:model.name||""} }
    Loader { anchors.fill: parent; source: "BackgroundVideo.qml" }
    Rectangle { anchors.fill: parent; color: "#52090e0b" }
    NumberAnimation on dial { from:0;to:360;duration:26000;loops:Animation.Infinite }

    // Brass debt clock at top left.
    Rectangle {
        x:45*root.s;y:42*root.s;width:445*root.s;height:112*root.s;color:"#df15130e";border.width:3*root.s;border.color:root.brass;opacity:root.ui
        Text{id:clock;x:22*root.s;y:12*root.s;text:Qt.formatTime(new Date(),"HH:mm");color:root.paper;font.family:"Noto Sans Mono";font.pixelSize:52*root.s;font.bold:true;Timer{interval:1000;running:true;repeat:true;onTriggered:clock.text=Qt.formatTime(new Date(),"HH:mm")}}
        Text{x:210*root.s;y:20*root.s;text:"DEBT LEDGER";color:root.brass;font.family:"Noto Sans Mono";font.pixelSize:12*root.s;font.bold:true;font.letterSpacing:3*root.s}
        Text{x:210*root.s;y:48*root.s;text:"£500,000";color:root.blood;font.family:"Noto Sans Mono";font.pixelSize:28*root.s;font.bold:true}
        Text{x:210*root.s;y:82*root.s;text:"ONE WEEK // FOUR FINGERS";color:root.paper;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;font.letterSpacing:1.5*root.s}
    }

    // Rotating evidence dial.
    Item {
        anchors.right:parent.right;anchors.rightMargin:60*root.s;anchors.top:parent.top;anchors.topMargin:35*root.s;width:230*root.s;height:230*root.s;opacity:root.ui
        Repeater{model:3;Rectangle{anchors.centerIn:parent;width:(215-index*45)*root.s;height:width;radius:width/2;color:"transparent";border.width:(index+1)*root.s;border.color:index===0?root.brass:(index===1?root.blood:root.paper);opacity:.55-index*.1;rotation:root.dial*(index%2?-.7:1)+index*50;Rectangle{width:9*root.s;height:9*root.s;radius:width/2;color:parent.border.color;anchors.horizontalCenter:parent.horizontalCenter;y:-height/2}}}
        Text{anchors.centerIn:parent;text:"12\nBORE";horizontalAlignment:Text.AlignHCenter;color:root.paper;font.family:"Noto Sans Mono";font.pixelSize:23*root.s;font.bold:true}
    }

    // Evidence tags scattered around the table.
    Repeater {
        model:[{x:70,y:220,r:-3,t:"EXHIBIT A // TWO BARRELS"},{x:590,y:210,r:2,t:"EXHIBIT B // THREE-CARD BRAG"},{x:620,y:300,r:-2,t:"EXHIBIT C // CASH + WEED"}]
        Rectangle{x:modelData.x*root.s;y:modelData.y*root.s;width:285*root.s;height:60*root.s;rotation:modelData.r;color:"#dfead9b7";border.width:2*root.s;border.color:"#674c2d";opacity:root.ui;Text{anchors.centerIn:parent;text:modelData.t;color:"#2a2119";font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true;font.letterSpacing:1.5*root.s}}
    }

    // Card-code authentication tray.
    Rectangle {
        id:tray;width:900*root.s;height:210*root.s;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:parent.bottom;anchors.bottomMargin:30*root.s;color:"#e515211b";border.width:3*root.s;border.color:root.brass;opacity:root.ui
        Rectangle{anchors.fill:parent;anchors.margins:9*root.s;color:"transparent";border.width:root.s;border.color:"#6bb94736"}
        Row {
            x:25*root.s;y:22*root.s;spacing:13*root.s
            Repeater{model:["A♠","K♥","Q♣","J♦"];Rectangle{width:74*root.s;height:88*root.s;radius:5*root.s;color:index===Math.min(3,password.text.length%4)?root.paper:"#84715a";rotation:index%2?-2:2;Text{anchors.centerIn:parent;text:modelData;color:index%2?root.blood:"#211a13";font.family:"Noto Serif";font.pixelSize:22*root.s;font.bold:true}}}
        }
        Column {
            x:355*root.s;y:20*root.s;width:510*root.s;spacing:8*root.s
            Text{text:"CARD SHARP // "+(((users.currentItem&&users.currentItem.uName)?users.currentItem.uName:(typeof userModel!=="undefined"?userModel.lastUser:"EDDIE")).toUpperCase());color:root.paper;font.family:"Noto Sans Mono";font.pixelSize:12*root.s;font.bold:true;font.letterSpacing:2*root.s}
            Rectangle{width:510*root.s;height:55*root.s;color:"#e00d1210";border.width:2*root.s;border.color:password.activeFocus?root.brass:root.blood
                TextInput{id:password;anchors.fill:parent;anchors.leftMargin:15*root.s;anchors.rightMargin:155*root.s;echoMode:TextInput.Password;passwordCharacter:"♦";color:root.brass;font.family:"Noto Sans Mono";font.pixelSize:19*root.s;font.letterSpacing:8*root.s;verticalAlignment:TextInput.AlignVCenter;focus:true;enabled:!root.authenticating;onTextEdited:errorText.text="";Keys.onReturnPressed:root.startAuth();Keys.onEnterPressed:root.startAuth()}
                Text{anchors.left:parent.left;anchors.leftMargin:15*root.s;anchors.verticalCenter:parent.verticalCenter;text:"PLACE YOUR HAND";visible:password.text.length===0;color:"#81735f";font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.letterSpacing:2*root.s}
                Rectangle{width:140*root.s;anchors.top:parent.top;anchors.bottom:parent.bottom;anchors.right:parent.right;color:deal.containsMouse?root.brass:"#342519";border.width:root.s;border.color:root.brass;Text{anchors.centerIn:parent;text:root.authenticating?"SHUFFLING…":"DEAL / UNLOCK";color:deal.containsMouse?"#1a130e":root.brass;font.family:"Noto Sans Mono";font.pixelSize:10*root.s;font.bold:true}MouseArea{id:deal;anchors.fill:parent;hoverEnabled:true;enabled:!root.authenticating;cursorShape:Qt.PointingHandCursor;onClicked:root.startAuth()}}
                MouseArea{anchors.left:parent.left;anchors.right:parent.right;anchors.rightMargin:145*root.s;anchors.top:parent.top;anchors.bottom:parent.bottom;onClicked:password.forceActiveFocus()}
            }
            Row{spacing:22*root.s;Text{id:errorText;width:285*root.s;text:"";color:root.blood;font.family:"Noto Sans Mono";font.pixelSize:9*root.s;font.bold:true}Text{visible:!root.isQuickshell;text:(sessions.currentItem&&sessions.currentItem.sName?sessions.currentItem.sName:"SESSION").toUpperCase();color:root.paper;font.family:"Noto Sans Mono";font.pixelSize:8*root.s}Text{text:"REBOOT";color:root.brass;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.reboot()}}Text{text:"SHUTDOWN";color:root.blood;font.family:"Noto Sans Mono";font.pixelSize:8*root.s;MouseArea{anchors.fill:parent;onClicked:if(typeof sddm!=="undefined")sddm.powerOff()}}}
        }
    }

    // Shuffle wipe: cards fly across before authentication.
    Repeater{model:8;Rectangle{z:1000;width:90*root.s;height:130*root.s;radius:7*root.s;x:(root.shuffle*1.5-index*.12)*root.width;y:(80+index*72)*root.s;rotation:root.shuffle*540+index*33;color:index%2?root.paper:root.blood;border.width:2*root.s;border.color:root.brass;opacity:root.authenticating?.9:0}}
    Rectangle{anchors.fill:parent;z:1100;color:root.brass;opacity:root.flash}
    NumberAnimation{id:intro;target:root;property:"ui";from:0;to:1;duration:800}
    ParallelAnimation{id:auth;NumberAnimation{target:root;property:"shuffle";from:-.4;to:1.4;duration:850;easing.type:Easing.InOutExpo}SequentialAnimation{PauseAnimation{duration:700}NumberAnimation{target:root;property:"flash";from:0;to:1;duration:130}}onFinished:root.doLogin()}
    Timer{interval:300;running:true;onTriggered:password.forceActiveFocus()}Timer{id:watchdog;interval:8000;onTriggered:root.resetAuth("")}
    Component.onCompleted:{keyboard.numLock=true;intro.start()}
    function startAuth(){if(root.authenticating||password.text.length===0){password.forceActiveFocus();return}root.authenticating=true;root.shuffle=-.4;root.flash=0;auth.restart()}
    function doLogin(){let u=(users.currentItem&&users.currentItem.uLogin)?users.currentItem.uLogin:(typeof userModel!=="undefined"?userModel.lastUser:"user");if(typeof sddm!=="undefined")sddm.login(u,password.text,root.sessionIndex);watchdog.restart()}
    function resetAuth(m){root.authenticating=false;root.shuffle=-.4;root.flash=0;password.text="";errorText.text=m;password.forceActiveFocus()}
    Connections{target:typeof sddm!=="undefined"?sddm:null;ignoreUnknownSignals:true;function onLoginFailed(){watchdog.stop();root.resetAuth("BAD HAND // DEBT REMAINS")}function onLoginSucceeded(){watchdog.stop()}function onInformationMessage(m){errorText.text=(m||"").toUpperCase()}function onErrorMessage(m){errorText.text=(m||"").toUpperCase()}}
}
