import QtQuick 2.15
import "qrc:/qmlutils" as PegasusUtils


FocusScope {
    id: root

    property alias withTitle: panel.withTitle
    property alias withMultiplayer: panel.withMultiplayer
    property alias withFavorite: panel.withFavorite
    property alias withDate: panel.withDate

    signal closeRequested

    Keys.onPressed: {
        if (event.isAutoRepeat) {
            return;
        }

        if (api.keys.isCancel(event) || api.keys.isFilters(event)) {
            event.accepted = true;
            closeRequested();
        }
    }

    FilterPanel {
        id: panel
        z: 400
        focus: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        visible: false
    }

    states: [
        State {
            name: "open"; when: root.focus
            AnchorChanges {
                target: panel
                anchors.bottom: undefined
                anchors.top: parent.top
            }
        }
    ]
    transitions: [
        Transition {
            to: "open"
            onRunningChanged: {
                if (running)
                    panel.visible = true;
            }
            AnchorAnimation { duration: 200; easing.type: Easing.OutCubic }
        },
        Transition {
            from: "open"
            onRunningChanged: {
                if (!running)
                    panel.visible = false;
            }
            AnchorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    ]

}