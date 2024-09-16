#!/usr/bin/env bash
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#

# -----------------------------导入脚本------------------------------ #
# 重置函数脚本
# 重置函数脚本中同时引入了 subl_start_close_func.sh 脚本
source ./subl_reset_func.sh

# ------------------------------------------------------------------ #

# ----------------------------函数区-------------------------------- #

# 复制 .sublime-settings 配置文件
function subl_cp_settings() {

	# settings 路径
	local settings_path=$1

	# 目标settings 路径
	local target_settings_path=$2

	# 复制 settings
	echo -e "\e[96m开始复制 settings...\n \e[0m"
	# 检测 settings 文件是否存在
	if [[ -f $settings_path ]]; then

		echo -e "\e[96m 如果已存在的 settings，将会被覆盖...\n \e[0m"
		cp -f -v $settings_path $target_settings_path
		if [[ $? == 0 ]]; then
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
function subl_cp_global_defualt_settings() {

	# 源
	local s_settings_path=./subl_settings/default_settings.sublime-settings

	# 目标
	local t_settings_path=~/.config/sublime-text/Packages/User/Preferences.sublime-settings

	subl_cp_settings $s_settings_path $t_settings_path

}

# 检测 Package Control 安装后相应的lib是否加载完
# ~/.config/sublime-text/Lib/python38/目录下是否存在package_control.py文件
# 不用检测 ~/~/.config/sublime-text/Lib/python33/目录
# 因为python3.3 只支持老的插件，新插件都是要求3.8的
function exists_packagecontrol_lib() {

	# 检测结果
	local is_exist="y"

	local lib_dir="$HOME/.config/sublime-text/Lib/python38/"

	# lib文件名
	local lib_file="package_control.py"

	# 判断lig文件是否存在
	if [[ ! -f "$lib_dir$lib_file" ]]; then
		is_exist="n"
	fi

	# 返回检测结果
	echo $is_exist

}

# 安装 Package Control
function install_packagecontrol() {

	#检测目录
	local subldir=$HOME/.config/sublime-text/'Installed Packages'
	# Package Control 包路径
	local pcfile=$subldir/'Package Control.sublime-package'
	#echo $pcfile

	if [ ! -f "$pcfile" ]; then
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

# 初始化主函数
function init_main() {

	# 重置
	resetAll

	# 复制 全局默认 settings
	# subl_cp_settings default_settings.json
	subl_cp_global_defualt_settings

	# 安装 Package Control
	install_packagecontrol

	# 重启
	subl_restart

	sleep 5

	# 获取 SublimeText 的 pid
	# 如果获取到则 SublimeText 正在运行
	local sub_pid=$(pidof sublime_text)

	if [[ -z $sub_pid ]]; then
		echo -e "\e[96m 请手动重启SublimeText，以完成 Package Control 安装... \n \e[0m"
	fi

	echo -e "\e[96m 初始化完成！\n \e[0m"

	# 重启Sublime Text
	# subl_restart

}

# ------------------------------------------------------------------ #

# 重启SublimeText
#
#echo "关闭 Sublime Text..."
#pkill -f "sublime_text"

# echo -e "\e[96m 请自行重启 Sublime Text! \e[0m"
