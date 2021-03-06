#!/bin/bash

plasmoidName=$(kreadconfig5 --file="$PWD/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name")
plasmoidName="${plasmoidName##*.}" # Strip namespace (Eg: "org.kde.plasma.")
plasmoidVersion=$(kreadconfig5 --file="$PWD/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Version")
filename=${plasmoidName}-v${plasmoidVersion}.plasmoid
pushd package
zip -r ../$filename *
popd
echo "md5: $(md5sum $filename | awk '{ print $1 }')"
echo "sha256: $(sha256sum $filename | awk '{ print $1 }')"
