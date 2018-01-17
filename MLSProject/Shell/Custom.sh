#!/bin/sh

# 修改项目名称以及版本号

if [ "Debug" == "${CONFIGURATION}" ]; then

DisplayName=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
DisplayName="${DisplayName}"

if [ "MinLison" == "${PRODUCT_NAME}" ]; then
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName MLSProject$DisplayName" "$INFOPLIST_FILE"
else
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName MLSProject$DisplayName" "$INFOPLIST_FILE"
fi


else

if [ "MinLison" == "${PRODUCT_NAME}" ]; then
DisplayName="MLSProject"
else
DisplayName="MLSProject"
fi

BuildNumber=$(date +%Y%m%d%H%M%S)

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $DisplayName" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BuildNumber" "$INFOPLIST_FILE"

fi

# rswift 自动生成代码 (结合项目内的图片, xib, storyboard, 本地化数据)
"$SRCROOT/Shell/Rswift/rswift" "$SRCROOT/Shell"

#export REVEAL_SERVER_FILENAME="RevealServer.framework"
#
## Update this path to point to the location of RevealServer.framework in your project.
#export REVEAL_SERVER_PATH="${SRCROOT}/${REVEAL_SERVER_FILENA38ME}"

## If configuration is not Debug, skip this script.
#[ "${CONFIGURATION}" != "Debug" ] && exit 0
#
## If RevealServer.framework exists at the specified path, run code signing script.
#if [ -d "${REVEAL_SERVER_PATH}" ]; then
#"${REVEAL_SERVER_PATH}/Scripts/copy_and_codesign_revealserver.sh"
#else
#echo "Cannot find RevealServer.framework, so Reveal Server will not be started for your app."
#fi

