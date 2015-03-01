import QtQuick 2.1
import "../../../js/Database.js" as Database
import "../../../js/Credentials.js" as Credentials
import "../../../js/PopupBlocker.js" as PopupBlocker

Item
{
    id: listener

    QtObject
    {
        readonly property var dispatcher: { "console_log": onConsoleLog,
                                            "console_error": onConsoleError,
                                            "touchstart": onTouchStart,
                                            "longpress": onLongPress,
                                            "submit": onFormSubmit,
                                            "selector_touch": onSelectorTouched,
                                            "newtab": newTabRequested,
                                            "window_open": onWindowOpen,
                                            "play_youtube": playYouTubeVideo,
                                            "play_vimeo": playVimeoVideo }

        id: listenerprivate

        function onConsoleLog(data) {
            console.log(data.log);
        }

        function onConsoleError(data) {
            console.error(data.log);
        }

        function onTouchStart(/* data */) {
            actionbar.evaporate();
            sidebar.collapse();
        }

        function onLongPress(data) {
            credentialdialog.hide();
            formresubmitdialog.hide();

            if(data.url) {
                linkmenu.url = data.url;
                linkmenu.isimage = data.isimage;
                linkmenu.show();
            }
            else if(data.text)
                pageStack.push(Qt.resolvedUrl("../../../pages/TextSelectionPage.qml"), { "text": data.text });
        }

        function onFormSubmit(data) {
            linkmenu.hide();

            if((mainwindow.settings.clearonexit === false) && Credentials.needsDialog(Database.instance(), mainwindow.settings, url.toString(), data)) {
                credentialdialog.url = url.toString();
                credentialdialog.logindata = data;
                credentialdialog.show();
            }
        }

        function onSelectorTouched(data) {
            webview.itemSelectorIndex = data.selectedIndex;
        }

        function newTabRequested(data) {
            tabview.addTab(data.url);
        }

        function playYouTubeVideo(data) {
            tabheader.solidify();
            navigationbar.solidify();
            viewstack.push(Qt.resolvedUrl("../views/youtube/YouTubeSettings.qml"), "youtubesettings", { "videoId": data.videoid });
        }

        function playVimeoVideo(data) {
            tabheader.solidify();
            navigationbar.solidify();
            viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserPlayer.qml"), "mediplayer", { "videoSource": data.videourl, "videoThumbnail": data.thumbnail, "videoTitle": data.title });
        }

        function onWindowOpen(data) {
            var rule = PopupBlocker.getRule(Database.instance(), data.url);

            if(rule === PopupBlocker.NoRule)
                actionbar.blockedPopups.appendPopup(data.url);
            else if(rule === PopupBlocker.AllowRule)
                tabview.addTab(data.url);
            /* else if(rule === PopupBlocker.BlockRule)
                Just Ignore It */
        }
    }

    function execute(message)
    {
        var data = JSON.parse(message.data);
        var eventfn = listenerprivate.dispatcher[data.type];

        if(eventfn)
            eventfn(data);
    }
}
