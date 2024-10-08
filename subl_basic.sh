#!/usr/bin/env bash
#-------------------------------------------------------------#
#		Sublime Text 基础配置脚本	    	      #
#		初始化及安装一些基础插件		      #
#-------------------------------------------------------------#

# --------------------------引入脚本--------------------------- #

# 重置函数脚本
# 重置函数脚本已经引入了subl_start_close_func.sh
source ./subl_reset_func.sh

# 初始化脚本
source ./subl_init_func.sh

# 下载脚本
source ./subl_downpackage_func.sh

# ----------------------------函数定义---------------------------- #

# 批量安装插件
function batch_install_plugins() {

	# 关闭 Sublime Text
	echo -e "\e[96m暂时关闭 Sublimet Text 并开始进行批量插件安装... \n \e[0m"
	subl_close

	# 重启Sublime Text
	# subl_restart

	# 读取插件地址文件安装插件
	local addr_file=basic_packages.txt
	install_package_by_addrfile $addr_file

	# 复制 basic settings
	local s_setings_path=./subl_settings/basic_gruvbox_settings.sublime-settings
	local t_settings_path=$HOME/.config/sublime-text/Packages/User/Preferences.sublime-settings
	subl_cp_settings $s_setings_path $t_settings_path

}

# basic 主函数
function basic_main() {

	echo -e "\e[96m 开始对 SublimeText 基础化配置...\n \e[0m"

	# 初始化主函数
	# 删除相关配置及缓存目录及安装 Package Control
	init_main

	# echo -e "\e[96m 重启及等待 Package Control 安装完成... \n \e[0m"

	# 重启Sublime Text
	subl_restart
	sleep 3

	# 检测 package_control.py 是否存在
	# .config/sublime-text/Lib/python38/package_control.py
	# .config/sublime-text/Installed Packages0_package_control_loader.sublime-package 是否存在
	# 0_package_control_loader.sublime-package 未手动重启前是存在，这时python38/package_control.py是未生成的
	# 手动重启后 python38/package_control.py被清理掉而不存在，而python38/package_control.py被生成这才完成Package Control的安装
	lib_exists=$(exists_packagecontrol_p38lib)

	if [[ $lib_exists == "y" ]]; then
		# 批量安装插件
		batch_install_plugins

		echo -e "\e[96m Sublime Text basic 插件集安装完成！ \n \e[0m"
		echo -e "\e[96m 插件生效可能需要重启 Sublime Text！ \e[0m"
	else
		#
		echo -e "\e[96m$HOME/.config/sublime-text/Lib/python38/ \e[93m目录下并未存在 \e[96m'package_control.py'文件，Package Control \e[93m安装未完成！  \n \e[0m"
	fi
}

# ----------------------------执行---------------------------- #

basic_main
