#!/bin/sh

# 修改项目名称以及版本号
if [ "Debug" == "${CONFIGURATION}" ]; then

DisplayName=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
DisplayName="${DisplayName}"

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName 测试$DisplayName" "$INFOPLIST_FILE"

else

DisplayName="MLSProject"
BuildNumber=$(date +%Y%m%d%H%M%S)

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $DisplayName" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BuildNumber" "$INFOPLIST_FILE"

fi

# rswift 自动生成代码 (结合项目内的图片, xib, storyboard, 本地化数据)
"$SRCROOT/Shell/Rswift/rswift" "$SRCROOT/Resource"

