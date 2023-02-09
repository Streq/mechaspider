#!/bin/bash
#DONT TOUCH THIS FILE
declare -A d
#comment out keys without value 
#otherwise gh will prompt for a paste
d[BUTLER_API_KEY]="somekey"
d[GODOT_VERSION]=3.4.4
d[ITCH_PROJECT_NAME]=my-game
d[ITCH_USERNAME]=user
d[PROJECT_NAME]="My Game"
d[DISCORD_WEBHOOK]="somehook"
d[RELEASE_LINUX]=true
d[RELEASE_WINDOWS]=true
d[RELEASE_MAC]=true
d[RELEASE_HTML5]=true
d[PUSH_TO_ITCH]=false
d[UPLOAD_TO_GH_PAGES]=true
for i in "${!d[@]}"
do
	gh secret set $i -b "${d[$i]}"
done