
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#


#-----------------------------导入脚本------------------------------#


# ------------------------------------------------------------------ #


# ----------------------------函数区-------------------------------- #

# 复制 Preferences.sublime-settings
function subl_cp_settings(){

  # 复制 settings
  echo -e "\e[96m 复制 settings! \e[0m"
  echo -e "\e[96m 如果已存在的 settings，将会被覆盖...\n \e[0m"
  cp -f -v ./base_settings.json ~/.config/sublime-text/Packages/User/Preferences.sublime-settings 

  if [ $? == 0 ];then
    echo -e "\e[92m \e[37m \n Preferences.sublime-settings \e[92m复制成功！\n \e[0m"
  else
    echo -e "\e[91m \e[37m \n Preferences.sublime-settings \e[91m复制失败！\n \e[0m"
  fi

}

# 安装 Package Control
function install_packagecontrol(){

  #检测目录
  subldir=~/.config/sublime-text/'Installed Packages'
  # Package Control 包路径
  pcfile=$subldir/'Package Control.sublime-package'
  #echo $pcfile

  if [ ! -f "$pcfile" ];then
    # 安装 Package Control插件
    echo -e "\e[96m 安装 Package Control...\n \e[0m"

    #curl https://packagecontrol.io/Package%20Control.sublime-package --output ~/.config/sublime-text/'Installed Packages'/'Package Control.sublime-package' --progress-bar

    #curl https://packagecontrol.io/Package%20Control.sublime-package --output "$subldir/Package Control.sublime-package" --progress-bar

    #wget -P ~/.config/sublime-text/Installed\ Packages/ 'https://packagecontrol.io/Package Control.sublime-package'

    wget -P "$subldir" 'https://packagecontrol.io/Package Control.sublime-package'

  else
    echo -e "\e[92m Package Control 已经安装了！\n \e[0m"
  fi

}


# ------------------------------------------------------------------ #

# 重启SublimeText
#
#echo "关闭 Sublime Text..."
#pkill -f "sublime_text"

# echo -e "\e[96m 请自行重启 Sublime Text! \e[0m"

