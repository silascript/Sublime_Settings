
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#



echo -e "\e[96m 开始对 SublimeText 初始化...\n \e[0m"

#检测目录
subldir=~/.config/sublime-text/'Installed Packages'

echo -e "\e[96m 开始检测相关目录... \e[0m"

if [ ! -d "$subldir" ];then
  echo -e "\e[93m \e[94m$subldir \e[93m目录不存在！\e[0m"
  echo -e "\e[96m 为了生成相关的目录,现在启动 SublimeText...\n \e[0m"
  subl
  # 休眠，等待Sublime Text 启动完成
  sleep 5

else
  echo -e "\e[92m 目录检测通过!\n \e[0m"
fi

# ------------------------------------------------------------------ #

# 关闭 Sublime Text

# 检测 Sublime Text 是否已经启动
subl_pid_count=`pgrep 'sublime_text' -l|wc -l`

if [ $subl_pid_count -gt 0 ];then
  # 获取 sublime_text 的进程PID
  subl_pid=`pgrep 'sublime_text' -l|awk '{print $1}'`
  #echo $subl_pid

  # 关闭 sublime_text 进程
  echo -e "\e[96m Sublime Text已经启动，现先将其关闭...\n \e[0m"
  kill $subl_pid 
  sleep 3

fi


# ------------------------------------------------------------------ #

# 复制 settings
echo -e "\e[96m 复制 settings! \e[0m"
echo -e "\e[96m 如果已存在的 settings，将会被覆盖...\n \e[0m"
cp -f -v ./base_settings.json ~/.config/sublime-text/Packages/User/Preferences.sublime-settings 

if [ $? == 0 ];then
  echo -e "\e[92m \e[37m \n Preferences.sublime-settings \e[92m复制成功！\n \e[0m"
  echo
else
  echo -e "\e[91m \e[37m \n Preferences.sublime-settings \e[91m复制失败！\n \e[0m"
fi

# ------------------------------------------------------------------ #

pcfile=$subldir/'Package Control.sublime-package'
#echo $pcfile

if [ ! -f "$pcfile" ];then
  # 安装 Package Control插件
  echo -e "\e[96m 安装 Package Control... \e[0m"

  #curl https://packagecontrol.io/Package%20Control.sublime-package --output ~/.config/sublime-text/'Installed Packages'/'Package Control.sublime-package' --progress-bar

  #curl https://packagecontrol.io/Package%20Control.sublime-package --output "$subldir/Package Control.sublime-package" --progress-bar

  #wget -P ~/.config/sublime-text/Installed\ Packages/ 'https://packagecontrol.io/Package Control.sublime-package'

  wget -P "$subldir/" 'https://packagecontrol.io/Package Control.sublime-package'

else
  echo -e "\e[92m Package Control 已经安装了！\n \e[0m"
fi

# ------------------------------------------------------------------ #

# 重启SublimeText
#
#echo "关闭 Sublime Text..."
#pkill -f "sublime_text"

# echo -e "\e[96m 请自行重启 Sublime Text! \e[0m"

