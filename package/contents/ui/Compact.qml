import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
  Layout.fillWidth: true // fill panel margin
  Layout.fillHeight: true
  Layout.minimumWidth: 5 * units.gridUnit
  Layout.maximumWidth: plasmoid.screenGeometry.width

  property alias icon: iconItem.source
  property alias body: label.text

  RowLayout {
    id: container

    property int widthHint: parent.width

    Layout.preferredWidth: widthHint
    Layout.maximumWidth: widthHint
    Layout.preferredHeight: parent.height
    Layout.maximumHeight: parent.height
    anchors.verticalCenter: parent.verticalCenter // effective
    // anchors.fill: parent
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

      visible: valid
      animated: false

      onValidChanged: {
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

    PlasmaComponents.Label {
      id: label

      // should be set for elide
      // WHY: parent.width is not effective
      Layout.preferredWidth: parent.widthHint - (iconItem.visible ? iconItem.width : 0) - parent.spacing

      // should be PlainText otherwise neither elide nor maximumLineCount works
      textFormat: Text.PlainText
      elide: Text.ElideRight
      maximumLineCount: 1
    }
  }
}
