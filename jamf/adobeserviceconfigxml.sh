#!/bin/bash

configpath="/Library/Application Support/Adobe/OOBE/Configs"

ServiceConfig="<config><panel><name>AppsPanel</name><visible>false</visible></panel><panel><name>FilesPanel</name><masked>true</masked></panel><panel><name>MarketPanel</name><masked>true</masked></panel><feature><name>SelfServeInstalls</name><enabled>false</enabled></feature><feature><name>BrowserBasedAuthentication</name><enabled>false</enabled></feature><feature><name>SelfServePluginsInstall</name><enabled>false</enabled></feature><feature><name>AppsAutoUpdate</name><enabled>false</enabled></feature><feature><name>AdobeFallbackForAUSST</name><enabled>false</enabled></feature><feature><name>AppsCategories</name><enabled>false</enabled><data><categories><category>beta-apps</category></categories></data></feature></config>"

echo -n "$ServiceConfig" > "$configpath/ServiceConfig.xml"