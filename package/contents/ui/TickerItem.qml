import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

RowLayout {
  id: tickerItem

  property alias icon: iconItem.source
  property string body

  clip: true
  spacing: units.smallSpacing

  // FIXME sometimes fails to load JPEG images
  PlasmaCore.IconItem {
    id: iconItem

    // TODO make configureable
    Layout.preferredWidth: units.iconSizeHints.panel
    Layout.preferredHeight: units.iconSizeHints.panel
    // Layout.preferredWidth: units.iconSizes.small
    // Layout.preferredHeight: units.iconSizes.small
    // required to center iconItem and label
    Layout.topMargin: (parent.height - Layout.preferredHeight) / 2
    Layout.bottomMargin: Layout.topMargin

    visible: valid
    animated: false

    // WHY: onValidChanged doesn't works
    onVisibleChanged: {
      // TODO remove log output for security
      if (!valid) console.log('IconItem: source (%1) is not valid'.arg(source));
    }
  }

  // Image { // fallback of iconItem
  //   width: units.iconSizeHints.panel
  //   height: width
  //
  //   fillMode: Image.PreserveAspectCrop
  //   source: iconItem.source
  //   visible: !iconItem.visible && status === Image.Ready
  // }

  // horizontal scrolling ticker
  Item {
    id: scrollingLabelContainer

    property real scrollLeft: 0
    property bool scrollEnabled: headLabel.implicitWidth > scrollingLabelContainer.width

    Layout.preferredWidth: tickerItem.width - (iconItem.visible ? iconItem.width : 0) - tickerItem.spacing
    Layout.preferredHeight: scrollingLabel.height

    clip: true

    RowLayout {
      id: scrollingLabel

      // anchors.top: parent.top
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: scrollingLabelContainer.scrollLeft

      spacing: units.largeSpacing

      PlasmaComponents.Label {
        id: headLabel

        text: tickerItem.body
        // should be PlainText otherwise neither elide nor maximumLineCount works
        textFormat: Text.PlainText
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      PlasmaComponents.Label {
        id: tailLabel

        text: tickerItem.body
        // should be PlainText otherwise neither elide nor maximumLineCount works
        textFormat: Text.PlainText
        elide: Text.ElideRight
        maximumLineCount: 1
        visible: scrollingLabelContainer.scrollEnabled
      }
    }

    SequentialAnimation on scrollLeft {
      running: scrollingLabelContainer.scrollEnabled

      PauseAnimation { duration: 3000 }
      NumberAnimation {
        to: -headLabel.implicitWidth - scrollingLabel.spacing
        // velocity: 6 gu / sec
        duration: -to / (0.006 * units.gridUnit)
      }
    }
  }

  state: 'PRE_SHOWN' // initial state

  states: [
    State {
      name: 'PRE_SHOWN'
      AnchorChanges {
        target: tickerItem
        anchors.bottom: tickerItem.parent.top
      }
    },
    State {
      name: 'SHOWN'
      AnchorChanges {
        target: tickerItem
        anchors.bottom: undefined // reset
        anchors.verticalCenter: tickerItem.parent.verticalCenter
      }
    },
    State {
      name: 'DISAPPEARED'
      AnchorChanges {
        target: tickerItem
        anchors.verticalCenter: undefined // reset
        anchors.top: tickerItem.parent.bottom
      }
      StateChangeScript {
        name: 'destroy'
        script: tickerItem.destroy()
      }
    }
  ]
  transitions: [
    Transition {
      to: 'SHOWN'
      AnchorAnimation { duration: units.longDuration }
    },
    Transition {
      to: 'DISAPPEARED'
      SequentialAnimation {
        AnchorAnimation { duration: units.longDuration }
        ScriptAction { scriptName: 'destroy' }
      }
    }
  ]
}
