import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
  id: main

  // anchors.fill: parent
  property var model: new Object()

  property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
  Plasmoid.preferredRepresentation: isDesktopContainment ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation
  Plasmoid.compactRepresentation: Compact {
    icon: model.appIcon
    body: model.body.replace(/\r?\n/g, '⏎')
  }
  // Plasmoid.fullRepresentation: Ticker {
    // delegate: FullTickerItem
  // }
  Plasmoid.fullRepresentation: Compact {
    body: 'Full'
  }

  PlasmaCore.DataSource {
    id: notificationsSource

    engine: 'notifications'
    interval: 0 // no polling
    // connectedSources: ['org.freedesktop.Notifications']

    onSourceAdded: {
      console.log('onSourceAdded: source: ' + source);
      connectSource(source);
    }

    onNewData: {
      console.log('onNewData: source: ' + data.source + ', appName: ' + data.appName);
      console.log('id: ' + data.id)
      console.log('summary: ' + data.summary)
      console.log('body: ' + data.body)
      // console.log('onNewData: icon: ' + data.icon + ', image: ' + data.image);
      console.log(Object.keys(data));
      // console.log(data.appIcon);
      // FIXME icon? image? appIcon?
      // imageItem.image = data.image;
      // iconItem.source = data.appIcon;
      // label.text = data.body;

      model = data;
    }
  }
}
