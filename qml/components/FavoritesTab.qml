import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

SilicaListView
{
    signal urlRequested(string favoriteurl)

    id: favoritestab
    clip: true
    model: mainwindow.settings.favorites

    delegate: ListItem {
        id: listitem
        contentHeight: Theme.itemSizeSmall
        width: favoritestab.width

        menu: ContextMenu {
            MenuItem {
                id: miedit
                text: qsTr("Edit");

                onClicked: pageStack.push(Qt.resolvedUrl("../pages/BookmarkPage.qml"), {"settings": mainwindow.settings, "index": index, "title": title, "url": url });
            }

            MenuItem {
                id: midelete
                text: qsTr("Delete");

                onClicked: listitem.remorseAction(qsTr("Deleting Bookmark"),
                                                  function() {
                                                      var favoriteurl = mainwindow.settings.favorites.get(index).url;
                                                      Favorites.remove(Database.instance(), mainwindow.settings.favorites, favoriteurl);
                                                  });
            }
        }

        onClicked: urlRequested(url);

        Row {
            anchors.fill: parent
            spacing: Theme.paddingSmall

            FavIcon
            {
                id: imgfavicon;
                anchors.verticalCenter: parent.verticalCenter
                site: url
            }

            Label {
                id: lbltitle;
                height: parent.height
                width: favoritestab.width - imgfavicon.width
                text: title
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                truncationMode: TruncationMode.Fade
                color: listitem.down ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
