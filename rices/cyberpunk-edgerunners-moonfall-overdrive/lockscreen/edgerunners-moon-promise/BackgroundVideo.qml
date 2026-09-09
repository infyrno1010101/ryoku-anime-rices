import QtQuick
import QtQuick.Window
import QtMultimedia

Item {
    anchors.fill: parent

    MediaPlayer {
        id: player
        source: "bg.mp4"
        autoPlay: true
        loops: MediaPlayer.Infinite
        videoOutput: output
    }

    VideoOutput {
        id: output
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }
}
