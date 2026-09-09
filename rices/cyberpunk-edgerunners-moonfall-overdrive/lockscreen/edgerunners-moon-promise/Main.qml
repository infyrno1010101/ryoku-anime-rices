import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#02040b"

    readonly property real s: Screen.height / 1080
    readonly property color yellow: "#f6ed00"
    readonly property color cyan: "#00efff"
    readonly property color pink: "#ff286e"
    readonly property color ice: "#eaf8ff"
    readonly property color voidColor: "#050814"
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property real ui: 0
    property real noisePhase: 0
    property real ringAngle: 0
    property bool authenticating: false
    property real authCharge: 0
    property real flashOpacity: 0
    property real shakeX: 0

    ListView {
        id: userHelper
        model: typeof userModel !== "undefined" ? userModel : null
        currentIndex: root.userIndex
        width: 1; height: 1; opacity: 0
        delegate: Item {
            property string uName: model.realName || model.name || ""
            property string uLogin: model.name || ""
        }
    }

    ListView {
        id: sessionHelper
        model: typeof sessionModel !== "undefined" ? sessionModel : null
        currentIndex: root.sessionIndex
        width: 1; height: 1; opacity: 0
        delegate: Item { property string sName: model.name || "" }
    }

    Loader { anchors.fill: parent; source: "BackgroundVideo.qml" }

    // Cinematic vignette leaves Lucy and the lunar window visible while the
    // authentication terminal occupies a separate dark rail on the right.
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#6e020611" }
            GradientStop { position: 0.46; color: "#08020611" }
            GradientStop { position: 0.72; color: "#59020611" }
            GradientStop { position: 1.0; color: "#ef020611" }
        }
    }

    // Fine moving scanlines—subtle enough to preserve the moon scene.
    Item {
        anchors.fill: parent
        opacity: 0.12
        Repeater {
            model: Math.ceil(root.height / 7)
            Rectangle {
                x: 0
                y: index * 7 * root.s + (root.noisePhase % (7 * root.s))
                width: root.width
                height: Math.max(1, root.s)
                color: index % 5 === 0 ? root.cyan : "#ffffff"
                opacity: index % 5 === 0 ? 0.20 : 0.07
            }
        }
    }

    NumberAnimation on noisePhase {
        from: 0; to: 7 * root.s; duration: 620; loops: Animation.Infinite
    }
    NumberAnimation on ringAngle {
        from: 0; to: 360; duration: 24000; loops: Animation.Infinite
    }

    // Lunar orbital clock: not a calendar widget, just the current time.
    Item {
        id: lunarClock
        x: 58 * root.s
        y: 62 * root.s
        width: 390 * root.s
        height: 390 * root.s
        opacity: root.ui
        rotation: root.shakeX * 0.08

        Repeater {
            model: 3
            Rectangle {
                anchors.centerIn: parent
                width: (360 - index * 46) * root.s
                height: width
                radius: width / 2
                color: "transparent"
                border.width: index === 0 ? 2 * root.s : root.s
                border.color: index === 0 ? root.cyan : (index === 1 ? root.pink : root.yellow)
                opacity: 0.34 - index * 0.06
                rotation: root.ringAngle * (index % 2 ? -0.75 : 1.0)
                Rectangle {
                    width: 12 * root.s; height: 12 * root.s; radius: width / 2
                    color: index === 0 ? root.cyan : (index === 1 ? root.pink : root.yellow)
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: -height / 2
                    layer.enabled: true
                    layer.effect: DropShadow { radius: 18; samples: 25; color: parent.color }
                }
            }
        }

        Text {
            id: timeText
            anchors.centerIn: parent
            text: Qt.formatTime(new Date(), "HH:mm")
            color: root.ice
            font.family: "Noto Sans Mono"
            font.pixelSize: 78 * root.s
            font.bold: true
            font.letterSpacing: -4 * root.s
            Timer { interval: 1000; running: true; repeat: true; onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm") }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: timeText.bottom
            anchors.topMargin: 10 * root.s
            text: "LUNAR TERMINAL // 2076"
            color: root.cyan
            font.family: "Noto Sans Mono"
            font.pixelSize: 13 * root.s
            font.bold: true
            font.letterSpacing: 4 * root.s
        }
    }

    // Story line: emotionally tied to the moon promise without copying the
    // desktop wallpaper's violent combat typography.
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 72 * root.s
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 74 * root.s
        spacing: 8 * root.s
        opacity: root.ui
        Text {
            text: "WISH WE COULD GO"
            color: root.ice
            font.family: "Noto Sans Mono"
            font.pixelSize: 20 * root.s
            font.bold: true
            font.letterSpacing: 7 * root.s
        }
        Text {
            text: "TO THE MOON TOGETHER."
            color: root.yellow
            font.family: "Noto Sans Mono"
            font.pixelSize: 34 * root.s
            font.bold: true
            font.letterSpacing: 3 * root.s
        }
        Rectangle { width: 420 * root.s; height: 3 * root.s; color: root.pink }
        Text {
            text: "DAVID // LUCY  ·  SIGNAL LOST / MEMORY ALIVE"
            color: root.cyan
            font.family: "Noto Sans Mono"
            font.pixelSize: 11 * root.s
            font.letterSpacing: 2 * root.s
        }
    }

    // Right-side authentication rail.
    Rectangle {
        id: rail
        width: 510 * root.s
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        x: root.shakeX
        color: "#c8050711"
        border.width: 2 * root.s
        border.color: "#5f00efff"
        opacity: root.ui

        Rectangle { width: 4 * root.s; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left; color: root.yellow }
        Rectangle { width: root.authCharge * parent.width; height: 4 * root.s; anchors.left: parent.left; anchors.top: parent.top; color: root.pink }

        Column {
            id: panel
            width: 390 * root.s
            anchors.right: parent.right
            anchors.rightMargin: 58 * root.s
            anchors.verticalCenter: parent.verticalCenter
            spacing: 18 * root.s

            Row {
                width: parent.width
                spacing: 10 * root.s
                Rectangle {
                    width: 12 * root.s; height: width; radius: width / 2; color: root.authenticating ? root.pink : root.cyan
                    SequentialAnimation on opacity { loops: Animation.Infinite; NumberAnimation { from: 1; to: .25; duration: 360 } NumberAnimation { from: .25; to: 1; duration: 360 } }
                }
                Text {
                    text: root.authenticating ? "NEURAL HANDSHAKE IN PROGRESS" : "LUCY // MOON-PROMISE NODE"
                    color: root.authenticating ? root.pink : root.cyan
                    font.family: "Noto Sans Mono"; font.pixelSize: 12 * root.s; font.bold: true; font.letterSpacing: 2 * root.s
                }
            }

            Text {
                text: "WELCOME BACK,\n" + (((userHelper.currentItem && userHelper.currentItem.uName) ? userHelper.currentItem.uName : (typeof userModel !== "undefined" ? userModel.lastUser : "EDGERUNNER")).toUpperCase())
                color: root.ice
                font.family: "Noto Sans Mono"
                font.pixelSize: 28 * root.s
                font.bold: true
                lineHeight: 1.18
            }

            Text {
                width: parent.width
                text: "ARASAKA ICE IS ACTIVE. AUTHENTICATE TO REENTER NIGHT CITY."
                wrapMode: Text.WordWrap
                color: "#9cb9c9"
                font.family: "Noto Sans Mono"
                font.pixelSize: 11 * root.s
                font.letterSpacing: 1.3 * root.s
            }

            Item {
                width: parent.width; height: 64 * root.s
                Rectangle {
                    anchors.fill: parent; color: "#d8040811"; border.width: 2 * root.s
                    border.color: password.activeFocus ? root.yellow : root.cyan
                    Behavior on border.color { ColorAnimation { duration: 120 } }
                }
                TextInput {
                    id: password
                    anchors.fill: parent
                    anchors.leftMargin: 18 * root.s; anchors.rightMargin: 18 * root.s
                    color: root.yellow
                    font.family: "Noto Sans Mono"; font.pixelSize: 23 * root.s; font.letterSpacing: 10 * root.s
                    echoMode: TextInput.Password; passwordCharacter: "◆"
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true; clip: true
                    cursorVisible: true; selectionColor: root.pink
                    enabled: !root.authenticating
                    onTextEdited: errorText.text = ""
                    Keys.onReturnPressed: root.startAuth()
                    Keys.onEnterPressed: root.startAuth()
                }
                Text {
                    anchors.left: parent.left; anchors.leftMargin: 18 * root.s; anchors.verticalCenter: parent.verticalCenter
                    text: "ENTER ACCESS SHARD"
                    visible: password.text.length === 0
                    color: "#668ba2"; font.family: "Noto Sans Mono"; font.pixelSize: 12 * root.s; font.letterSpacing: 3 * root.s
                }
                MouseArea { anchors.fill: parent; onClicked: password.forceActiveFocus() }
            }

            Row {
                spacing: 8 * root.s
                Repeater {
                    model: 12
                    Rectangle {
                        width: 25 * root.s; height: 5 * root.s
                        color: index < Math.min(12, password.text.length) ? (index < 8 ? root.cyan : root.pink) : "#263647"
                        Behavior on color { ColorAnimation { duration: 90 } }
                    }
                }
            }

            Text {
                id: errorText
                width: parent.width
                height: 20 * root.s
                text: ""
                color: root.pink
                font.family: "Noto Sans Mono"; font.pixelSize: 11 * root.s; font.bold: true; font.letterSpacing: 2 * root.s
            }

            Rectangle {
                width: parent.width; height: 52 * root.s
                color: loginMouse.containsMouse ? root.yellow : "#1700efff"
                border.width: 2 * root.s; border.color: root.yellow
                Behavior on color { ColorAnimation { duration: 120 } }
                Text {
                    anchors.centerIn: parent
                    text: root.authenticating ? "S4NDEVISTAN // CHARGING" : "BREACH // UNLOCK"
                    color: loginMouse.containsMouse ? root.voidColor : root.yellow
                    font.family: "Noto Sans Mono"; font.pixelSize: 14 * root.s; font.bold: true; font.letterSpacing: 3 * root.s
                }
                MouseArea { id: loginMouse; anchors.fill: parent; hoverEnabled: true; enabled: !root.authenticating; cursorShape: Qt.PointingHandCursor; onClicked: root.startAuth() }
            }

            Row {
                anchors.right: parent.right
                spacing: 24 * root.s
                Text {
                    visible: !root.isQuickshell
                    text: (sessionHelper.currentItem && sessionHelper.currentItem.sName ? sessionHelper.currentItem.sName : "SESSION").toUpperCase()
                    color: sessionMouse.containsMouse ? root.yellow : "#7b94a5"; font.family: "Noto Sans Mono"; font.pixelSize: 10 * root.s
                    MouseArea { id: sessionMouse; anchors.fill: parent; hoverEnabled: true; onClicked: if (typeof sessionModel !== "undefined" && sessionModel.rowCount() > 0) root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount() }
                }
                Text {
                    text: "REBOOT"; color: rebootMouse.containsMouse ? root.yellow : "#7b94a5"; font.family: "Noto Sans Mono"; font.pixelSize: 10 * root.s
                    MouseArea { id: rebootMouse; anchors.fill: parent; hoverEnabled: true; onClicked: if (typeof sddm !== "undefined") sddm.reboot() }
                }
                Text {
                    text: "SHUTDOWN"; color: offMouse.containsMouse ? root.pink : "#7b94a5"; font.family: "Noto Sans Mono"; font.pixelSize: 10 * root.s
                    MouseArea { id: offMouse; anchors.fill: parent; hoverEnabled: true; onClicked: if (typeof sddm !== "undefined") sddm.powerOff() }
                }
            }
        }
    }

    // Unlock velocity wipe.
    Rectangle { anchors.fill: parent; color: root.yellow; opacity: root.flashOpacity; z: 1000 }
    Repeater {
        model: 14
        Rectangle {
            z: 999
            width: 10 * root.s; height: root.height * 1.7
            x: -300 * root.s + index * 170 * root.s + root.authCharge * 950 * root.s
            y: -root.height * .3
            rotation: 24
            color: index % 2 ? root.cyan : root.pink
            opacity: root.authenticating ? .32 : 0
        }
    }

    NumberAnimation { id: intro; target: root; property: "ui"; from: 0; to: 1; duration: 950; easing.type: Easing.OutCubic }
    ParallelAnimation {
        id: authAnimation
        NumberAnimation { target: root; property: "authCharge"; from: 0; to: 1; duration: 720; easing.type: Easing.InExpo }
        SequentialAnimation {
            PauseAnimation { duration: 550 }
            NumberAnimation { target: root; property: "flashOpacity"; from: 0; to: 1; duration: 150 }
        }
        onFinished: root.doLogin()
    }
    SequentialAnimation {
        id: failureShake
        NumberAnimation { target: root; property: "shakeX"; to: 18 * root.s; duration: 45 }
        NumberAnimation { target: root; property: "shakeX"; to: -15 * root.s; duration: 55 }
        NumberAnimation { target: root; property: "shakeX"; to: 10 * root.s; duration: 50 }
        NumberAnimation { target: root; property: "shakeX"; to: 0; duration: 70 }
    }
    Timer { interval: 320; running: true; onTriggered: password.forceActiveFocus() }
    Timer { id: authWatchdog; interval: 8000; onTriggered: root.resetAuth("") }

    Component.onCompleted: {
        keyboard.numLock = true
        intro.start()
    }

    function startAuth() {
        if (root.authenticating || password.text.length === 0) {
            password.forceActiveFocus()
            return
        }
        root.authenticating = true
        root.authCharge = 0
        root.flashOpacity = 0
        authAnimation.restart()
    }

    function doLogin() {
        let user = (userHelper.currentItem && userHelper.currentItem.uLogin) ? userHelper.currentItem.uLogin : (typeof userModel !== "undefined" ? userModel.lastUser : "user")
        if (typeof sddm !== "undefined") sddm.login(user, password.text, root.sessionIndex)
        authWatchdog.restart()
    }

    function resetAuth(message) {
        root.authenticating = false
        root.authCharge = 0
        root.flashOpacity = 0
        password.text = ""
        errorText.text = message
        password.forceActiveFocus()
    }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        ignoreUnknownSignals: true
        function onLoginFailed() { authWatchdog.stop(); root.resetAuth("ACCESS DENIED // RETRY SHARD"); failureShake.restart() }
        function onLoginSucceeded() { authWatchdog.stop() }
        function onInformationMessage(message) { errorText.text = (message || "").toUpperCase() }
        function onErrorMessage(message) { errorText.text = (message || "").toUpperCase() }
    }
}
