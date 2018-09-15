import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
  id: main

  property var model
  property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating

  Plasmoid.icon: (model && model.appIcon) ? model.appIcon : 'preferences-desktop-notification'
  Plasmoid.toolTipMainText: (model && model.summary) ? model.summary : 'Ticker'
  Plasmoid.toolTipSubText: (model && model.body) ? model.body : null
  Plasmoid.preferredRepresentation: isDesktopContainment ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation
  Plasmoid.compactRepresentation: Ticker {
    model: main.model
  }
  // TODO notifications history list
  Plasmoid.fullRepresentation: Item {}

  PlasmaCore.DataSource {
    id: notificationsSource

    engine: 'notifications'
    interval: 0 // no polling

    onSourceAdded: {
      console.log('onSourceAdded: source: ' + source);
      connectSource(source);
    }

    onNewData: {
      // TODO remove log output for security
      // console.log('sourceName: ' + sourceName);
      // console.log('sources: ' + notificationsSource.sources)
      // console.log('connectedSources: ' + notificationsSource.connectedSources)
      // console.log('keysForSource' + notificationsSource.data.keys())
      // console.log('data: ' + notificationsSource.data[sourceName])
      // for (var k in data) {
      //   console.log('%1: %2'.arg(k).arg(data[k]))
      // }

      var _data = Object.create(data); // shallow copy
      _data.originalBody = data.body;
      _data.body = sanitizeIllFormatedHtml(data.body);
      _data.onelineBody = _data.body.replace(/<br\/>/g, '⏎');
      model = _data;
    }
  }

  function sanitizeIllFormatedHtml(s) {
    if (!s) return null;

    // model.body may be ill-formated HTML-like string
    // ex: "<?xml version="1.0"?><html>Ping!</html><?xml version="1.0"?><html>Pong!</html>"
    // split last one part of HTML document
    var m = s.match(/<html>.*<\/html>/g);
    if (!m) return null;
    // FIXME remove all HTML tags and replace &gt; with >
    return m[m.length - 1].replace(/<html>(.*)<\/html>/, '$1');
  }
}
