
echo "开始初始化 Sublime..."

#检测目录
subldir=~/.config/sublime-text/'Installed Packages'

if [ ! -d "$subldir" ];then
  echo "目录不存在！"
  echo "为了生成相关的目录,启动下SublimeText..."
  subl
else
  echo "目录存在！"
fi

echo "开始设置..."

#cd -

# ------------------------------------------------------------------ #

echo "复制settings..."
cp -v ./base_settings.json ~/.config/sublime-text/Packages/User/Preferences.sublime-settings 

if [ $? == 0 ];then
	echo "settings复制成功！"
else
	echo "settings复制失败！"
fi

# ------------------------------------------------------------------ #

# 安装 Package Control插件
echo "安装 Package Control..."

#curl https://packagecontrol.io/Package%20Control.sublime-package --output ~/.config/sublime-text/'Installed Packages'/'Package Control.sublime-package' --progress-bar

#curl https://packagecontrol.io/Package%20Control.sublime-package --output "$subldir/Package Control.sublime-package" --progress-bar

#wget -P ~/.config/sublime-text/Installed\ Packages/ 'https://packagecontrol.io/Package Control.sublime-package'

wget -P "$subldir/" 'https://packagecontrol.io/Package Control.sublime-package'



# 重启SublimeText
#
#echo "关闭 Sublime Text..."
#pkill -f "sublime_text"

echo "请自行重启 Sublime Text!"

