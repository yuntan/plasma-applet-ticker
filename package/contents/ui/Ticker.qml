import QtQuick 2.0
import QtQuick.Layouts 1.1

// vertical scrolling ticker
Item {
  id: ticker

  property var model

  // private:
  property Item __currentTickerItem

  onModelChanged: {
    // TODO default icon and text
    // TODO configureable default text
    if (!model) return;

    var props = {
      // FIXME icon? image? appIcon?
      icon: model.appIcon,
      body: model.onelineBody,
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
