#!/bin/bash
set -e

CHROME_DIRECTORY="wayback_machine_chrome"
FIREFOX_DIRECTORY="wayback_machine_firefox"

copy_action() {
	mkdir "$1"
	cp background.js manifest.json README.md "$1"/
	cp -r assets "$1"/

	if [[ "$1" == *"firefox" ]]; then
		cp manifest_firefox.json "$1"
		cd "$1" && mv manifest_firefox.json manifest.json
	fi
}

release_chrome() {
	copy_action $CHROME_DIRECTORY
	cd $CHROME_DIRECTORY && 7z a -tzip -mx9 ../$CHROME_DIRECTORY.zip *
	cd .. && rm -rf $CHROME_DIRECTORY
}

release_firefox() {
	copy_action $FIREFOX_DIRECTORY
	sed -i 's/chrome/browser/g' "background.js"
	sed -i 's/action/browserAction/g' "background.js"
	7z a -tzip -mx9 ../$FIREFOX_DIRECTORY.zip *
	cd .. && rm -rf $FIREFOX_DIRECTORY
}

release_chrome
release_firefox
