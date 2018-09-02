import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

RowLayout {
  id: tickerItem

  property alias icon: iconItem.source
  property alias body: label.text

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
    Layout.topMargin: (parent.height - Layout.preferredHeight) / 2
    Layout.bottomMargin: Layout.topMargin

    visible: valid
    animated: false

    // WHY: onValidChanged doesn't works
    onVisibleChanged: {
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

  // TODO horizontal schrolling text
  PlasmaComponents.Label {
    id: label

    // should be set for elide
    Layout.preferredWidth: parent.width - (iconItem.visible ? iconItem.width : 0) - parent.spacing

    // should be PlainText otherwise neither elide nor maximumLineCount works
    textFormat: Text.PlainText
    elide: Text.ElideRight
    maximumLineCount: 1
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
