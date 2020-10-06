#!/usr/bin/env bash

hdiutil create -volname Dockex -srcfolder _build/prod/app -ov -format UDZO _build/prod/Dockex.dmg
