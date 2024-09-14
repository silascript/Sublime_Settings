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

	# 读取插件地址文件安装插件
	local addr_file=basic_packages.txt
	install_package_by_addrfile $addr_file

	# 复制 basic settings
	local s_setings_path=./subl_settings/basic_gruvbox_settings.sublime-settings
	local t_settings_path=~/.config/sublime-text/Packages/User/Preferences.sublime-settings
	subl_cp_settings $s_setings_path $t_settings_path

	# 重启Sublime Text
	subl_restart
}

# ----------------------------执行---------------------------- #
echo -e "\e[96m 开始对 SublimeText 基础化配置...\n \e[0m"

# 初始化主函数
# 删除相关配置及缓存目录及安装 Package Control
init_main

# echo -e "\e[96m 重启及等待 Package Control 安装完成... \n \e[0m"

# 重启Sublime Text
subl_restart

sleep 5

# 批量安装插件
batch_install_plugins
