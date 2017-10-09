#!/bin/bash
export LANG=en_US.UTF-8

cat << EOF

usage:
./build.sh target build_type "描述文字"

example:
./build.sh ChengziZdd release/adhoc_online/adhoc_test "描述文字"

EOF

if [ "$#" -lt 1 ]; then
	echo "wrong paramters count, exit"
    exit
fi

target=$1
build_type=$2
change_text=$3


# working path
pushd `dirname $0` > /dev/null
working_path=`pwd`
popd > /dev/null

cd ${working_path}

# unlock keychain // use jekin unlock keychain
# 
# 
LOGIN_KEYCHAIN=~/Library/Keychains/login.keychain
LOGIN_PASSWORD=`cat ~/userName/ios/local_password.txt`
security unlock-keychain -p ${LOGIN_PASSWORD} ${LOGIN_KEYCHAIN}

echo "iOS_Command target:${target} build_type:${build_type} change_text:${change_text}"

# build
fastlane ios iOS_Command target:${target} build_type:${build_type} change_text:"${change_text}"
