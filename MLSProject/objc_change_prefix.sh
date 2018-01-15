#!/bin/bash
# 此脚本不能完全更改项目中的所有文件，需要在更改过后进行微调
#CLOSE XCODE BEFORE RUNNING THE SCRIPT. IT ALSO HAS GIT PRIVELEGES AND MESSES UP 
# GIT MV EXECUTED IN THIS PROJECT

# set -e
# 都更改哪些后缀类型的文件
all_extensions=".m .h .xib .storyboard"
prefix_from="MLS"
prefix_to=""
project_name=""
test_name=""

# 如果提示project文件找不到，请把下面的project, storyboard 路径换成绝对路径
project=`find ${project_name}.xcodeproj -name "project.pbxproj"`
storyboard=`find . -name "MainStoryboard.storyboard"`

# replace_filename_in_file $file_name $new_file_name $file_to_replace_pattern
# 更改文件内部的类前缀
replace_filename_in_file () {
  sed -e "s/\([^a-zA-Z]\)$1\([^a-zA-Z]\)/\1$2\2/g" \
      -e "s/^$1\([^a-zA-Z]\)/$2\1/g" \
      -e "s/\([^a-zA-Z]\)$1$/\1$2/g" \
      -e "s/^$1$/$2/g" -i '' $3
}
export -f replace_filename_in_file

# replace_filename_in_all_files $file_name $new_file_name
# 更改当前类在所有相关文件中的命名
# 例如当前类是AAAObject,在很多.h.m.xib中都有引用这个类，需要把所有引用这个类的文件都要更改一遍
replace_filename_in_all_files() {
  files_with_m=()
  files_with_m=`find $project_name -type f -name "*.m" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`
  files_with_m=(${files_with_m[@]} `find $test_name -type f -name "*.m" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`)

  files_with_h=()
  files_with_h=`find $project_name -type f -name "*.h" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`
  files_with_h=(${files_with_h[@]} `find $test_name -type f -name "*.h" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`)

  files_with_xib=()
  files_with_xib=`find $project_name -type f -name "*.xib" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`
  files_with_xib=(${files_with_xib[@]} `find $test_name -type f -name "*.xib" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`)

  files_with_storyboard=()
  files_with_storyboard=`find $project_name -type f -name "*.storyboard" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`
  files_with_storyboard=(${files_with_storyboard[@]} `find $test_name -type f -name "*.storyboard" -exec grep -l [^a-zA-Z]$1[^a-zA-Z] {} ";"`)

  stack=()

  ( for file_m in ${files_with_m[@]}; do
    replace_filename_in_file $1 $2 $file_m
  done )& stack[0]=$!

  ( for file_h in ${files_with_h[@]}; do
    replace_filename_in_file $1 $2 $file_h
  done )& stack[1]=$!

  ( for file_xib in ${files_with_xib[@]}; do
    replace_filename_in_file $1 $2 $file_xib
  done )& stack[2]=$!

  ( for files_storyboard in ${files_with_storyboard[@]}; do
    replace_filename_in_file $1 $2 $files_storyboard
  done )& stack[3]=$!

  ( replace_filename_in_file $1 $2 $project
  )& stack[4]=$!

  ( replace_filename_in_file $1 $2 $storyboard
  )& stack[5]=$!

  for job in ${stack[@]}; do
    wait $job
  done
}
export -f replace_filename_in_all_files

# replace_path $file_name $new_file_name $extension
# 更改本地文件名
replace_path () {
  all_old_paths=()
  all_old_paths=`find $project_name -type f -name "$1*$3"`
  all_old_paths=(${all_old_paths[@]} `find $test_name -type f -name "$1*$3"`)
  for old_path in ${all_old_paths[@]}
  do
    new_path=`echo $old_path | sed "s/$1/$2/g"`
    echo "Old path: $old_path"
    echo "New path: $new_path"
    # 本地git
    # git mv $old_path $new_path
    echo =====rename_filename start========
    echo ===$old_path===$new_path======
    # 重命名文件
    mv $old_path $new_path
    echo =====rename_file end========
  done
}
export -f replace_path


main () {
  # 用来记录文件是否更新过
  files_already_updated=()
  for extension in $all_extensions
  do
    files=()
    files=`find $project_name -type f -name "*$extension" | grep -o "\/\w*$extension*$" |
    sed "s/^\/\([a-zA-Z]*\)$extension$/\1/g"`
    files=(${files[@]} `find $test_name -type f -name "*$extension" | grep -o "\/\w*$extension*$" |
    sed "s/^\/\([a-zA-Z]*\)$extension$/\1/g"`)

    for file_name in ${files[@]}
    do
      if [[ "$file_name" == *"$prefix_from"* ]]; then
        file_name_without_prefix="${file_name:${#prefix_from}}"
        new_file_name="$prefix_to$file_name_without_prefix"
      else
        # 是否要给没有前缀的文件增加前缀
        # new_file_name="$prefix_to$file_name"
        new_file_name="$file_name"
        continue
      fi
      echo '---------------------------------------------'
      echo "Current file name: $file_name"
      echo "New file name: $new_file_name"
      echo "Rename file reference with name ending in *$extension"

      # 记录更新过的文件
      file_update_name="$file_name$extension"

      if [ "${files_already_updated[*]/%$file_update_name/}" == "${files_already_updated[*]}" ]
      then
        replace_filename_in_all_files $file_name $new_file_name
        replace_path $file_name $new_file_name $extension
        files_already_updated+=($file_update_name)
      fi
    done
  done

  # Sets standard header to new one
  # 设置新的类前缀配置文件
  sed -i "" -l "s/\(CLASSPREFIX = \)${prefix_from}/\1${prefix_to}/g" $project
}

main
