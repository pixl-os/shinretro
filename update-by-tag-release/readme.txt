Start
1. update number version in theme.cfg and readme.md and changelog.md and folder "update-by-tag-release" version.sh
2. in folder "update-by-tag-release" into file "install.sh" under line "rm /recalbox/share_init/themes/shinretro(version)" version = old number
2.1 add line "rm /recalbox/share_init/themes/shinretro(newversion)" newversion = last number
2.2 in folder "update-by-tag-release" into file "version.sh" change # version: (number) by the last
3. in gitkraken
4. clic right in branch pixL-master "create tag here"
5. name tag whith the last version check changelog.md
6. push this tag
7. clic right in the tag
8. push vx.xxx.x to origin
9. in your pc zip the folder "shinretro"
9.1 change name shinretro.zip to package.zip
10. go to https://github.com/pixl-os/shinretro/releases/new
11. choose a tag create in step 3
12. clic on "Generate release notes"
13. clic on "Set as a pre-release"
14. upload in "Attach binaries by dropping them here or selecting them." the files present into "update-by-tag-release" without readme.text and the shinretro.zip
15. clic on "Publish release"
Done
