#!/bin/bash

# 遍历每个子模块
git submodule foreach '
  # 硬编码新的URL前缀
  new_url_prefix="git@github.com:neatlogic/"
  
  # 获取当前子模块名称
  module_name=$(basename `git rev-parse --show-toplevel`)
  
  # 构造新的URL
  new_url="${new_url_prefix}${module_name}.git"
  
  # 获取当前远程仓库所有URL
  all_urls=$(git remote -v)

  # 检查新的URL是否已经存在
  if echo "$all_urls" | grep -q "$new_url"; then
    echo "$module_name 已经包含URL: $new_url"
  else
    echo "将为 $module_name 添加新的URL: $new_url"
    # 如果你确认无误后，取消下面一行的注释以实际添加URL
     git remote set-url --add origin $new_url
  fi
'

