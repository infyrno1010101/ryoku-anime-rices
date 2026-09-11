import QtQuick
import QtQuick.Window
import QtMultimedia
Item { anchors.fill: parent; MediaPlayer { id:p; source:"bg.mp4"; autoPlay:true; loops:MediaPlayer.Infinite; videoOutput:v } VideoOutput { id:v; anchors.fill:parent; fillMode:VideoOutput.PreserveAspectCrop } }
