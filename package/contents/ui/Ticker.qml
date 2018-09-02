import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
  id: ticker

  property var model

  function sanitizeIllFormatedHtml(body) {
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

  onModelChanged: {
    // newModel
    // animation.start();
  }

  Layout.fillWidth: true // fill panel margin
  Layout.fillHeight: true
  Layout.minimumWidth: 5 * units.gridUnit
  Layout.maximumWidth: plasmoid.screenGeometry.width

  TickerItem {
    widthHint: ticker.width

    Layout.preferredWidth: widthHint
    Layout.maximumWidth: widthHint
    Layout.preferredHeight: ticker.height
    Layout.maximumHeight: ticker.height
    anchors.verticalCenter: ticker.verticalCenter // effective

    // TODO default icon and text
    // TODO configureable default text
    // FIXME icon? image? appIcon?
    icon: model ? model.appIcon : null
    body: (model && model.body) ? sanitizeIllFormatedHtml(model.body) : null
  }
}
