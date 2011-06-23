#!/bin/sh

TP="/usr/local/bin/TexturePacker"

if [ "${ACTION}" = "clean" ]
then
echo "cleaning..."

rm resources/sprites-hd.pvr.ccz
rm resources/sprites-hd.plist

rm resources/flower-hd.pvr.ccz
rm resources/flower-hd.plist

# ....
# add all files to be removed in clean phase
# ....
else
echo "building..."

# create hd assets
${TP} --smart-update \
--format cocos2d \
--data resources/sprites-hd.plist \
--sheet resources/sprites-hd.pvr.ccz \
--dither-fs-alpha \
--opt RGBA4444 \
Art/sprites/*.jpg

${TP} --smart-update \
--format cocos2d \
--data resources/flower-hd.plist \
--sheet resources/flower-hd.pvr.ccz \
--dither-fs-alpha \
--opt RGB565 \
Art/flower/*.jpg

# ....
# add other sheets to create here
# ....
fi
exit 0