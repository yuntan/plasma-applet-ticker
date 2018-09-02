#!/bin/bash
kpackagetool5 -t Plasma/Applet -u package
killall plasmashell; kstart5 -- plasmashell
killall latte-dock; kstart5 -- latte-dock --debug
