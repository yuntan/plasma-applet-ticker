import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
  // anchors.fill: parent
  clip: true

  Layout.minimumWidth: 5 * units.gridUnit
  // Layout.minimumHeight: units.gridUnit
  // Layout.preferredWidth: 15 * units.gridUnit
  Layout.preferredWidth: plasmoid.screenGeometry.width
  // Layout.preferredHeight: units.gridUnit
  Layout.maximumWidth: plasmoid.screenGeometry.width

  property alias icon: iconItem.source
  property alias body: label.text

  Row {
    id: container

    anchors.verticalCenter: parent.verticalCenter
    // height: min(parent.height)
    spacing: 3

    PlasmaCore.IconItem {
      id: iconItem

      width: units.iconSizeHints.panel
      height: width

      visible: valid
      animated: false
    }

    PlasmaComponents.Label {
      id: label

      maximumLineCount: 1
      // text: "Hello world in Plasma 5 "
      // color: 'black'
    }
  }
}
