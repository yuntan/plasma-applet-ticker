import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
  id: ticker

  property var model

  // private:
  property Item __currentTickerItem

  function sanitizeIllFormatedHtml(body) {
    if (!body) return null;

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
    // TODO default icon and text
    // TODO configureable default text
    if (!model) return;

    var props = {
      // FIXME icon? image? appIcon?
      icon: model.appIcon,
      body: sanitizeIllFormatedHtml(model.body),
    };
    var o = tickerItemComponent.createObject(ticker, props);
    o.state = 'SHOWN';
    if (__currentTickerItem)
      __currentTickerItem.state = 'DISAPPEARED';
    __currentTickerItem = o;
  }

  Layout.fillWidth: true // fill panel margin
  Layout.fillHeight: true
  Layout.minimumWidth: 5 * units.gridUnit
  Layout.maximumWidth: plasmoid.screenGeometry.width

  Component {
    id: tickerItemComponent

    TickerItem {
      width: ticker.width
      height: ticker.height
      anchors.left: ticker.left
    }
  }
}
