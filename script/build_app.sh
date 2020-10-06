#!/bin/bash

rm -Rf _build/prod/app

MIX_ENV=prod mix release

mkdir -p _build/prod/app/dockex.app/Contents/MacOS
mkdir -p _build/prod/app/dockex.app/Contents/Resources
mkdir -p _build/prod/app/dockex.app/Contents/Frameworks

cp -rf resources/dockex.icns _build/prod/app/dockex.app/Contents/Resources/
cp -rf _build/prod/rel/dockex _build/prod/app/dockex.app/Contents/Resources/
cp -rf resources/dockex.sh _build/prod/app/dockex.app/Contents/MacOS/
cp -rf resources/run.sh _build/prod/app/dockex.app/Contents/Resources/
cp -rf resources/Info.plist _build/prod/app/dockex.app/Contents/Info.plist

chmod +x _build/prod/app/dockex.app/Contents/MacOS/dockex.sh
chmod +x _build/prod/app/dockex.app/Contents/Resources/run.sh
