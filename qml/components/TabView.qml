import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    id: tabview
    onWidthChanged: setTabWidth()
    onCurrentIndexChanged: setOpacities()
    Component.onCompleted: setOpacities()

    property ListModel pages: ListModel { }
    property real tabWidth: setTabWidth()
    property int currentIndex: 0

    /* BrowserTab Component */
    Component {
        id: tabcomponent
        BrowserTab { }
    }

    function setTabWidth()
    {
        if(!pages.count)
            return;

        var stdwidth = (headerrow.width - btnplus.width) / 2;

        if((pages.count * stdwidth) <= headerrow.width)
            tabview.tabWidth = stdwidth;
        else
            tabview.tabWidth = ((headerrow.width - btnplus.width) / pages.count);
    }

    function setOpacities()
    {
        for(var i = 0; i < pages.count; i++)
            pages.get(i).tab.visible = (i == currentIndex ? true : false);
    }

    function addTab(url)
    {
        var tab = tabcomponent.createObject(stack);
        tab.anchors.fill = stack

        if(url)
            tab.load(url);

        pages.append({ "tab": tab });
        currentIndex = (pages.count - 1);
        setOpacities();
        setTabWidth();
    }

    function removeTab(idx)
    {
        var tab = pages.get(idx).tab;
        pages.remove(idx);

        tab.parent = null /* Remove Parent Ownership */
        tab.destroy();    /* Destroy the tab immediately */

        if(currentIndex > 0)
            currentIndex--;

        setOpacities();
        setTabWidth();
    }

    RemorsePopup { id: tabviewremorse }

    Column
    {
        anchors.fill: parent

        Item
        {
            id: header
            height: Theme.iconSizeMedium
            anchors { left: parent.left;  right: parent.right }

            Row
            {
                id: headerrow
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                width: header.width - Theme.iconSizeMedium
                spacing: 2

                Repeater
                {
                    id: repeater
                    model: pages
                    anchors { left: parent.left; top: parent.top; right: parent.right }

                    delegate: Rectangle {
                        id: headeritem

                        width: tabview.tabWidth
                        height: header.height
                        color: (index === currentIndex ? Theme.secondaryColor : Theme.secondaryHighlightColor);

                        Behavior on width {
                            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                        }

                        MouseArea
                        {
                            id: headermousearea
                            width: parent.width - btnclose.width
                            height: parent.height

                            Image
                            {
                                id: favicon
                                width: headertitle.height
                                height: headertitle.height
                                fillMode: Image.PreserveAspectFit
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.paddingSmall
                                anchors.verticalCenter: parent.verticalCenter
                                source: tab.getIcon()
                                asynchronous: true
                                smooth: true
                            }

                            Text
                            {
                                id: headertitle
                                text: tab.getTitle()
                                font.pixelSize: Theme.fontSizeSmall
                                anchors.left: favicon.right
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: Theme.paddingSmall
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                clip: true
                            }

                            onClicked: {
                                currentIndex = index;
                            }
                        }

                        IconButton
                        {
                            id: btnclose
                            width: Theme.iconSizeSmall
                            height: Theme.iconSizeSmall
                            anchors.left: headermousearea.right
                            anchors.rightMargin: Theme.paddingSmall
                            anchors.verticalCenter: headermousearea.verticalCenter
                            icon.source: "image://theme/icon-close-vkb"
                            visible: pages.count > 1

                            onClicked: tabview.removeTab(index)
                        }
                    }
                }

                IconButton
                {
                    id: btnplus
                    width: Theme.iconSizeMedium
                    height: Theme.iconSizeMedium
                    icon.source: "image://theme/icon-m-add"
                    anchors.rightMargin: Theme.paddingSmall

                    onClicked: tabview.addTab()
                }
            }

            IconButton
            {
                id: btnsidebar
                icon.source: "image://theme/icon-lock-more"
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                anchors { left: headerrow.right; top: parent.top; bottom: parent.bottom; right: parent.right }
                onClicked: sidebar.visible = !sidebar.visible;
            }
        }

        Row
        {
            width: parent.width
            height: parent.height - header.height

            ActionSidebar
            {
                id: sidebar
                height: parent.height
            }

            Item
            {
                id: stack
                height: parent.height
                width: parent.width - (sidebar.visible ? sidebar.width : 0)
            }
        }
    }
}
