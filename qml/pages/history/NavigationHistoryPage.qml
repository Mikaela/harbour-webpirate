import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"
import "../../components/tabview"
import "../../js/settings/History.js" as History

Page
{
    property TabView tabView
    property HistoryModel historyModel: HistoryModel { }

    id: navigationhistorypage
    allowedOrientations: defaultAllowedOrientations

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        History.fetchAll(historyModel);
    }

    RemorsePopup { id: remorsepopup }

    SilicaListView
    {
        VerticalScrollDecorator { flickable: listview }

        BusyIndicator {
            id: busyindicator
            anchors.centerIn: parent
            running: historyModel.busy
            size: BusyIndicatorSize.Large
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete History")

                onClicked: {
                    remorsepopup.execute(qsTr("Deleting History"), function() {
                        History.clear();
                        historyModel.clear();
                    });
                }
            }
        }

        id: listview
        anchors.fill: parent
        model: historyModel
        quickScroll: true
        section.property: "date"
        section.criteria: ViewSection.FullString

        header: PageHeader {
            title: qsTr("Navigation History")
        }

        section.delegate: Component {
            SectionHeader { text: section; font.pixelSize: Theme.fontSizeSmall; height: Theme.itemSizeExtraSmall }
        }

        delegate: NavigationHistoryItem {
            id: navigationhistoryitem
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            titleFont: Theme.fontSizeSmall
            historyTime: time
            historyTitle: title
            historyUrl: url

            onClicked: {
                tabView.currentTab().load(url);
                pageStack.pop();
            }

            onOpenRequested: {
                tabView.currentTab().load(url);
                pageStack.pop();
            }

            onOpenNewTabRequested: {
                tabView.addTab(url);
                pageStack.pop();
            }

            onDeleteRequested: {
                History.remove(url);
                historyModel.remove(index);
            }
        }
    }
}
