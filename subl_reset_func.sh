

# ------------------------------------------------------------- #
# 			重置函数脚本
# ------------------------------------------------------------- #


# ---------------------------引入脚本-------------------------- #

# 关闭重启等
source ./subl_start_close_func.sh


# ----------------------------函数区---------------------------- #

# 删除 Sublime Text 相关目录
function delete_subl_dir(){

  #检测目录
  subldir=~/.config/sublime-text
  sublcachedir=~/.cache/sublime-text

  if [ ! -d "$subldir" ];then
    echo -e "\e[33m \e[93m \e[37m$subldir \e[93m目录不存在！\e[0m"
  else
    # 删除 ~/.config/sublime-text
    echo -e "\e[32m 将删除 $subldir 目录，并启动 Sublime Text，以便重新生成 $subldir \e[0m"
    rm -rvf $subldir
  fi

  if [ ! -d "$sublcachedir" ];then
    echo -e "\e[33m \e[37m$sublcachedir \e[93m目录不存在！\e[0m"
  else
    # 删除 ~/.cache/sublime-text
    rm -rvf $sublcachedir
  fi
}


# 清理.Cache目录
function clearCache(){
  # .Cache目录
  cdir=.Cache

  if [ -d $cdir ];then
    echo -e "\e[96m 清理 \e[93m$cdir \e[96m...\n \e[0m"
    rm -r $cdir/* 
  fi

}

# 删除 Sublime_Settings 下的 .Cache 目录
function delete_sscache_dir(){
  
  # .Cache目录
  cdir=.Cache

  if [ -d $cdir ];then
    echo -e "\e[96m 删除 \e[93m$cdir \e[96m...\n \e[0m"
    rm -rf $cdir 
  fi
}


# 所有相关目录
# 删除 ~/.config/sublime-text 目录
# 删除 ~/.cache/sublime-text 目录
# 删除 .Cache 目录
function deleteAll(){

  # 删除 ~/.config/sublime-text 目录
  # 删除 ~/.cache/sublime-text 目录
  delete_subl_dir 

  # 删除 .Cache 目录
  delete_sscache_dir

}

# 重置所有
function resetAll(){

  # 关闭 Sublime Text
  subl_close

  # 删除 Sublime Text 相关目录
  # 删除 .Cache 目录
  #delete_subl_dir
  deleteAll

  echo -e "\e[96m 现在重新启动 SublimeText... \e[0m"
  # 重启
  subl_restart


}



# ----------------------------------测试------------------------------ #

# 清理.Cache目录
#clearCache

# 删除相关目录
#resetAll


