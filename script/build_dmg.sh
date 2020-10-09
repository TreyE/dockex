#!/usr/bin/env bash

hdiutil create -volname Dockex -srcfolder _build/prod/app -ov -format UDBZ _build/prod/Dockex.dmg
