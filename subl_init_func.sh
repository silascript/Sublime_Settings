
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#


#-----------------------------导入脚本------------------------------#


# ------------------------------------------------------------------ #


# ----------------------------函数区-------------------------------- #

# 复制 .sublime-settings 配置文件
function subl_cp_settings(){
	
	# settings 路径
	settings_path=$1	
	
	# 目标settings 路径
	target_settings_path=$2

	# 复制 settings
	echo -e "\e[96m开始复制 settings...\n \e[0m"
	# 检测 settings 文件是否存在
	if [ -f $settings_path ];then

		echo -e "\e[96m 如果已存在的 settings，将会被覆盖...\n \e[0m"
		cp -f -v $settings_path $target_settings_path
		if [ $? == 0 ];then
			echo -e "\e[92m \e[37m$target_settings_path \e[92m复制成功！\n \e[0m"
		else
			echo -e "\e[91m \e[37m$target_settings_path \e[91m复制失败！\n \e[0m"
		fi
	else
		echo -e "\e[92m $settings_path \e[96m不存在！\n \e[0m"
	fi

}

# 复制全局默认配置
# 默认的 Preferences.sublime-settings 配置
function subl_cp_global_defualt_settings(){

	# 源
	s_settings_path=./subl_settings/default_settings.sublime-settings

	# 目标
	t_settings_path=~/.config/sublime-text/Packages/User/Preferences.sublime-settings

	subl_cp_settings $s_settings_path $t_settings_path

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

