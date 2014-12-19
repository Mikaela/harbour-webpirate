# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-webpirate

CONFIG += sailfishapp

SOURCES += src/harbour-webpirate.cpp \
    src/webviewdatabase.cpp

OTHER_FILES += qml/harbour-webpirate.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-webpirate.changes.in \
    rpm/harbour-webpirate.spec \
    rpm/harbour-webpirate.yaml \
    translations/*.ts \
    harbour-webpirate.desktop \
    qml/js/UrlHelper.js \
    qml/js/SearchEngines.js \
    qml/js/Favorites.js \
    qml/components/TabView.qml \
    qml/components/SearchBar.qml \
    qml/components/NavigationBar.qml \
    qml/components/LoadingBar.qml \
    qml/components/LoadFailed.qml \
    qml/components/BrowserTab.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/MainPage.qml \
    qml/js/UserAgents.js \
    qml/js/Database.js \
    qml/models/Settings.qml \
    qml/models/FavoritesModel.qml \
    qml/components/FavoritesView.qml \
    qml/js/WebViewHelper.js \
    qml/pages/SearchEnginesPage.qml \
    qml/pages/FavoritePage.qml \
    qml/pages/SearchEnginePage.qml \
    qml/models/SearchEngineModel.qml \
    qml/js/Credentials.js \
    qml/js/GibberishAES.js \
    qml/components/menus/PopupMenu.qml \
    qml/components/menus/LinkMenu.qml \
    qml/components/menus/CredentialMenu.qml \
    qml/components/menus/ItemSelector.qml \
    qml/components/menus/RequestMenu.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-webpirate.ts \
            translations/harbour-webpirate-ca.ts \
            translations/harbour-webpirate-it.ts \
            translations/harbour-webpirate-nl_NL.ts \
            translations/harbour-webpirate-ru_RU.ts \
            translations/harbour-webpirate-sv_SE.ts \
            translations/harbour-webpirate-de.ts

RESOURCES += \
    resources.qrc

HEADERS += \
    src/webviewdatabase.h
