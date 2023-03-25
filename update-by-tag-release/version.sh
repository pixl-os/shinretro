#!/bin/bash
# version: 0.201.3
themeName="shinretro"
#echo for debug
#echo "$themeName"

#direct reading of *.cfg to extract and return version string
result=""
result="$(awk -v FS='(version: )' '{print $2}' /recalbox/share_init/themes/"$themeName"/theme.cfg | tr -d '\n')"
if test -n "$result"
then
	#not null: we could return value normally
	echo v"$result" | tr -d '\n' | tr -d '\r'
else
	#value is not found or null - force to 0.0.0.0 in this case
	echo v0.0.0.0 | tr -d '\n' | tr -d '\r'
fi
exit 0