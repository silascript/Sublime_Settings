
echo -e "\e[36m 开始初始化 Sublime... \e[0m"

#检测目录
subldir=~/.config/sublime-text/'Installed Packages'

if [ ! -d "$subldir" ];then
  echo -e "\e[33m \e[34m$subldir目录不存在！\e[0m"
  echo -e "\e[36m 为了生成相关的目录,现在启动 SublimeText... \e[0m"
  subl
fi

echo -e "\e[36m 开始设置... \e[0m"

#cd -

# ------------------------------------------------------------------ #

echo -e "\e[36m 复制settings... \e[0m"
echo -e "\e[36m 如果已存在的settings，将会被覆盖... \e[0m"
cp -f -v ./base_settings.json ~/.config/sublime-text/Packages/User/Preferences.sublime-settings 

if [ $? == 0 ];then
	echo -e "\e[32m settings复制成功！\e[0m"
else
	echo -e "\e[31m settings复制失败！\e[0m"
fi

# ------------------------------------------------------------------ #

pcfile=$subldir/'Package Control.sublime-package'
#echo $pcfile

if [ ! -f "$pcfile" ];then
  # 安装 Package Control插件
  echo -e "\e[36m 安装 Package Control... \e[0m"

  #curl https://packagecontrol.io/Package%20Control.sublime-package --output ~/.config/sublime-text/'Installed Packages'/'Package Control.sublime-package' --progress-bar

  #curl https://packagecontrol.io/Package%20Control.sublime-package --output "$subldir/Package Control.sublime-package" --progress-bar

  #wget -P ~/.config/sublime-text/Installed\ Packages/ 'https://packagecontrol.io/Package Control.sublime-package'

  wget -P "$subldir/" 'https://packagecontrol.io/Package Control.sublime-package'
else
  echo -e "\e[32m Package Control 已经安装了！\e[0m"
fi

# 重启SublimeText
#
#echo "关闭 Sublime Text..."
#pkill -f "sublime_text"

echo -e "\e[36m 请自行重启 Sublime Text! \e[0m"

