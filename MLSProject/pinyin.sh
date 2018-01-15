#!/bin/sh

ROOT_PATH=$(dirname "$0")
ROOT_ENGLISH_PATH=$ROOT_PATH/english
ROOT_PINYIN_PATH=$ROOT_PATH/pinyin

check_pinyin_cmd()
{
  command -v ch2py > /dev/null 2>&1;
  if [ $? != 0 ]; then
		echo "install pin in use `sudo gem install chinese_pinyin` "
    sudo gem install chinese_pinyin
	fi
}

check_english_cmd()
{
  command -v translate-cli > /dev/null 2>&1;
  if [ $? != 0 ]; then
		echo "install pin in use `sudo pip install translate` "
    sudo pip install translate
	fi
}

list_alldir_use_english()
{
    for filename in `ls $1`
    do
      FILE_PATH="$1/$filename"
      FILE_NAME="${filename%.*}"

      FILE_NAME_WITH_OUT_SPACE=$FILE_NAME | sed 's/[[:space:]]//g' # 去除空格
      FILE_EXT="${filename##*@}"
      if [[ -d $FILE_PATH && ! $FILE_PATH = $ROOT_PINYIN_PATH && ! $FILE_PATH = $ROOT_ENGLISH_PATH ]]; then
         list_alldir_use_english "$FILE_PATH" #递归查找
      elif [[ -f "$FILE_PATH" && ! ${filename##*.} = "sh" ]]; then
          NEW_FILE_NAME=`echo $FILE_NAME | sed 's/@.*$//g' | sed 's/_//g'` #找出文件名
          ENGLISH_NAME=$(translate-cli -t en $NEW_FILE_NAME) # 翻译
          ENGLISH_NAME=`echo $ENGLISH_NAME | sed 's/[ ][ ]*/_/g' | tr '[A-Z]' '[a-z]'` # 替换空格为下划线,大写转小写
          echo $ENGLISH_NAME_LOWER
          NEW_FILE_FULL_NAME="${ENGLISH_NAME}@${FILE_EXT}"
          NEW_FILE_PATH="${ROOT_ENGLISH_PATH}/${NEW_FILE_FULL_NAME}"

          echo "cp $FILE_PATH to $NEW_FILE_PATH"
          cp $FILE_PATH $NEW_FILE_PATH

      fi
    done
    echo "-----转换完成-----"
}
list_alldir_use_pin_yin()
{
    for filename in `ls $1`
    do
      FILE_PATH="$1/$filename"
      FILE_NAME="${filename%.*}"

      FILE_NAME_WITH_OUT_SPACE=$FILE_NAME | sed 's/[[:space:]]//g' # 去除空格
      FILE_EXT="${filename##*@}"

      if [[ -d $FILE_PATH && ! $FILE_PATH = $ROOT_PINYIN_PATH && ! $FILE_PATH = $ROOT_ENGLISH_PATH ]]; then
         list_alldir_use_pin_yin "$FILE_PATH" #递归查找
      elif [[ -f "$FILE_PATH" && ! ${filename##*.} = "sh" ]]; then
          NEW_FILE_NAME=`echo $FILE_NAME | sed 's/@.*$//g' | sed 's/_//g'`
          PIN_YIN_NAME=$(ch2py $NEW_FILE_NAME -s _)
          PIN_YIN_NAME=${PIN_YIN_NAME/xuan_zhong/sel}
          PIN_YIN_NAME=${PIN_YIN_NAME/mo_ren/nor}

          NEW_FILE_FULL_NAME="${PIN_YIN_NAME}@${FILE_EXT}"
          NEW_FILE_PATH="${ROOT_PINYIN_PATH}/${NEW_FILE_FULL_NAME}"

          echo "rename $FILE_PATH to $NEW_FILE_PATH"
          cp $FILE_PATH $NEW_FILE_PATH
      fi
    done
    echo "-----转换完成-----"
}

print_usage()
{
  echo "-----------------------------"
  echo "pinyin.sh en 转英文"
  echo "pinyin.sh py 转拼音"
  echo "-----------------------------"
}

print_usage;

change_to_english()
{
    check_english_cmd;

    rm -r -f $ROOT_ENGLISH_PATH

    if [[ ! -d $ROOT_ENGLISH_PATH ]]; then
        mkdir -p $ROOT_ENGLISH_PATH
    fi

    list_alldir_use_english $ROOT_PATH;
}


change_to_pinyin()
{
    check_pinyin_cmd;

    rm -r -f $ROOT_PINYIN_PATH

    if [[ ! -d $ROOT_PINYIN_PATH ]]; then
        mkdir -p $ROOT_PINYIN_PATH
    fi
    list_alldir_use_pin_yin $ROOT_PATH;
}

if [[ $1 = "en" ]]; then
    change_to_english;
elif [[ $1 = "py" ]]; then
    change_to_pinyin;
fi
