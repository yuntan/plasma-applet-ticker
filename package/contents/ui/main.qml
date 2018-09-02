import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
  id: main

  property var model
  property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating

  Plasmoid.preferredRepresentation: isDesktopContainment ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation
  Plasmoid.compactRepresentation: Ticker {
    model: main.model
  }
  // TODO notifications history list
  Plasmoid.fullRepresentation: Item {}
  // TODO tooltip

  PlasmaCore.DataSource {
    id: notificationsSource

    engine: 'notifications'
    interval: 0 // no polling

    onSourceAdded: {
      console.log('onSourceAdded: source: ' + source);
      connectSource(source);
    }

    onNewData: {
      console.log('sourceName: ' + sourceName);
      console.log('sources: ' + notificationsSource.sources)
      console.log('connectedSources: ' + notificationsSource.connectedSources)
      // console.log('keysForSource' + notificationsSource.data.keys())
      console.log('data: ' + notificationsSource.data[sourceName])
      for (var k in data) {
        console.log('%1: %2'.arg(k).arg(data[k]))
      }

      model = data;
    }
  }
}
