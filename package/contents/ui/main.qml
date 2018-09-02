import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
  id: main

  property var model: new Object()
  property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating

  Plasmoid.preferredRepresentation: isDesktopContainment ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation
  Plasmoid.compactRepresentation: Compact {
    // TODO default icon and text
    // FIXME icon? image? appIcon?
    icon: model.appIcon
    body: {
      if (!(model && model.body)) return null;

      // model.body may be ill-formated HTML-like string
      // ex: "<?xml version="1.0"?><html>Ping!</html><?xml version="1.0"?><html>Pong!</html>"
      // split last one part of HTML document
      var m = model.body.match(/<html>.*<\/html>/g);
      if (!m) return null;
      // FIXME remove all HTML tags
      var text = m[m.length - 1].replace(/<html>(.*)<\/html>/, '$1');
      return text.replace(/<br\/>/g, '⏎');
    }
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
